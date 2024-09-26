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

task_tokens = {
    "joinToGame": 100,
    "visitToWebSite": 200,
    "joinToTelegramChannel": 500,
    "subscribeToTelegramChannel": 1000,
    "joinToTwitterChannel": 500,
}


class JsonData(BaseModel):
    token: str
    task_key: str


@router.post("/task")
async def task_handler(data: JsonData):
    if data.token is None:
        raise HTTPException(status_code=400, detail="JWT token is required")

    try:
        # Проверка валидности текущего JWT токена
        payload = jwt.decode(
            token=data.token,
            key=TELEGRAM_TOKEN,
            algorithms=[ALGORITHM],
        )
    except JWTError as e:
        logger.error(f"JWT error: {str(e)}", exc_info=True)
        raise HTTPException(status_code=400, detail="Invalid JWT token")

    telegram_id = payload.get("user_id")
    if telegram_id is None:
        raise HTTPException(status_code=400, detail="Invalid payload: user_id missing")

    task_info = await db.get_task_info(data.task_key, telegram_id)
    task_id, task_status, user_id = task_info.values()

    try:
        # Получение информации о задаче
        task_info = await db.get_task_info(data.task_key, telegram_id)
        task_id, task_status, user_id = task_info.values()

        # Проверка текущего статуса задачи
        if task_status != 2:
            # Обновление статуса задачи и баланса пользователя в одной транзакции
            tokens_earned = task_tokens[data.task_key]
            await db.update_status_task(
                task_id=task_id,
                new_status=2,
                user_id=user_id,
                tokens=tokens_earned,
            )

            logger.info(
                f"Task '{data.task_key}' completed successfully for user {telegram_id}."
            )

            return {
                "message": "Task completed successfully",
                "tokens_earned": tokens_earned,
            }
        else:
            raise HTTPException(
                status_code=405, detail=f"Task key alredy comlete: {data.task_key}"
            )

    except KeyError:
        raise HTTPException(
            status_code=400, detail=f"Invalid task_key: {data.task_key}"
        )
