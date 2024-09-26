from typing import Optional
import hashlib
import hmac
from operator import itemgetter
from urllib.parse import parse_qsl
from datetime import datetime, timedelta
from pytz import timezone
from fastapi import APIRouter, HTTPException, Request
from jose import jwt, JWTError
from common import Config, Logger
from database import db
from pydantic import BaseModel

logger = Logger.get("App")
router = APIRouter()
TELEGRAM_TOKEN = Config.telegram_token
ALGORITHM = "HS256"
MOSCOW_TZ = timezone("Europe/Moscow")


class TokenData(BaseModel):
    token: str


@router.post("/claim")
async def auth_user(token_data: TokenData):
    jwt_token = token_data.token
    if jwt_token is None:
        raise HTTPException(status_code=400, detail="JWT token is required")

    try:
        # Проверка валидности текущего JWT токена
        payload = jwt.decode(
            token=jwt_token,
            key=TELEGRAM_TOKEN,
            algorithms=[ALGORITHM],
        )
    except JWTError as e:
        logger.error(f"JWT error: {str(e)}", exc_info=True)
        raise HTTPException(status_code=400, detail="Invalid JWT token")

    user_id = payload.get("user_id")
    if user_id is None:
        raise HTTPException(status_code=400, detail="Invalid payload: user_id missing")
    print(user_id)
    # Получение данных пользователя из базы данных
    user_data = await db.get_user_data(user_id)
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")

    last_claim_timestamp = user_data.get("last_claim_timestamp")
    referrer_telegram_id = user_data.get("referrer_telegram_id")
    print(f"referral_telegram_id - {referrer_telegram_id}")
    now_moscow = datetime.now(MOSCOW_TZ)
    if last_claim_timestamp:
        last_claim_timestamp = last_claim_timestamp.astimezone(MOSCOW_TZ)
        time_diff = now_moscow - last_claim_timestamp

        if time_diff < timedelta(hours=8):
            raise HTTPException(
                status_code=400, detail="You can only claim tokens once every 8 hours"
            )

    # Обновление баланса и last_claim_timestamp
    if await db.update_balance_and_timestamp(user_id, 100):
        if referrer_telegram_id is not None:
            await db.update_reffer_balance(referrer_telegram_id, user_id, 20)
        return {"message": "Tokens claimed successfully"}
    else:
        logger.error(f"Database update error: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail="Internal server error")
