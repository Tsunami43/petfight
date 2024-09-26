from typing import Optional, Callable, Any, Dict
import hashlib
import hmac
import json
from operator import itemgetter
from urllib.parse import parse_qsl
from datetime import datetime, timedelta
from pytz import timezone, utc
from fastapi import APIRouter, HTTPException, Request
from jose import jwt
from common import Config, Logger
from database import db
from pydantic import BaseModel


logger = Logger.get("App")
router = APIRouter()
TELEGRAM_TOKEN = Config.telegram_token
ALGORITHM = "HS256"
MOSCOW_TZ = timezone("Europe/Moscow")


class Signature(BaseModel):
    init_data: str
    
    
class User(BaseModel):
    id: int

class QueryData(BaseModel):
    query_id: str
    user: User
    auth_date: str
    hash: str


@router.post("/auth")
async def auth_user(signature: Signature):
    try:
        parsed_data = safe_parse_webapp_init_data(TELEGRAM_TOKEN, signature.init_data, json.loads)
        data = QueryData(**parsed_data)
    except:
        raise HTTPException(status_code=400, detail="User is not check")
    db_user = await db.get_user_info(data.user.id)
    if db_user is None:
        logger.warning(f"User is not found")
        raise HTTPException(status_code=400, detail="User is not found")
    now_utc = datetime.now(utc)
    now_moscow = now_utc.astimezone(MOSCOW_TZ)
    exp_timestamp = int((now_moscow + timedelta(minutes=30)).timestamp())
    try:
        payload = {"user_id": db_user.get("user_id"), "exp": exp_timestamp}
        jwt_token = jwt.encode(claims=payload, key=TELEGRAM_TOKEN, algorithm=ALGORITHM)
        return {
            "token": jwt_token,
            "user": db_user.get("user"),
        }
    except Exception as e:
        logger.error(f"Error encoding JWT token: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to encode JWT token")


def check_webapp_signature(token: str, init_data: str) -> bool:
    """
    Check incoming WebApp init data signature

    Source: https://core.telegram.org/bots/webapps#validating-data-received-via-the-web-app

    :param token:
    :param init_data:
    :return:
    """
    try:
        parsed_data = dict(parse_qsl(init_data))
    except ValueError:
        # Init data is not a valid query string
        return False
    if "hash" not in parsed_data:
        # Hash is not present in init data
        return False
    print(parsed_data)
    hash_ = parsed_data.pop('hash')
    data_check_string = "\n".join(
        f"{k}={v}" for k, v in sorted(parsed_data.items(), key=itemgetter(0))
    )
    
    secret_key = hmac.new(
        key=b"WebAppData", msg=token.encode(), digestmod=hashlib.sha256
    )
    
    calculated_hash = hmac.new(
        key=secret_key.digest(), msg=data_check_string.encode(), digestmod=hashlib.sha256
    ).hexdigest()
    return calculated_hash == hash_


def parse_init_data(init_data: str, _loads: Callable[..., Any]) -> Dict[str, Any]:
    """
    Parse WebApp init data and return it as dict

    :param init_data:
    :param _loads:
    :return:
    """
    result = {}
    for key, value in parse_qsl(init_data):
        if (value.startswith('[') and value.endswith(']')) or (value.startswith('{') and value.endswith('}')):
            value = _loads(value)
        result[key] = value
    return result


def safe_parse_webapp_init_data(token: str, init_data: str, _loads: Callable[..., Any]) -> Dict[str, Any]:
    """
    Validate WebApp init data and return it as dict

    :param token:
    :param init_data:
    :param _loads:
    :return:
    """
    if check_webapp_signature(token, init_data):
        return parse_init_data(init_data, _loads)
    raise ValueError("Invalid init data signature")

