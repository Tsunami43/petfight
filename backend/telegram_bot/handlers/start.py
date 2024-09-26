from aiogram import Router
from aiogram.filters import Command
from aiogram.types import (
    WebAppInfo,
    Message,
    InlineKeyboardButton,
    InlineKeyboardMarkup,
)
import messages
from database import db
from common import Logger, Config
from provider import service_provider


logger = Logger.get("Telegram")

router = Router()
web_app_url = "htpps://"+Config.host_app


def button() -> InlineKeyboardMarkup:
    return InlineKeyboardMarkup(
        inline_keyboard=[
            [
                InlineKeyboardButton(
                    text="Play",
                    web_app=WebAppInfo(url=web_app_url),
                )
            ]
        ]
    )


def parser_reffer(text: str):
    try:
        return int(text.split()[1])
    except:
        return None


@router.message(Command("start"))
async def start_handler(message: Message):
    try:
        if not await db.user_exists(message.from_user.id):
            reffer = parser_reffer(message.text)
            if reffer is None:
                logger.info(
                    "New user %s[%s]", message.from_user.full_name, message.from_user.id
                )
            else:
                logger.info(
                    "New user %s[%s] with reffer %s",
                    message.from_user.full_name,
                    message.from_user.id,
                    reffer,
                )
            await service_provider.register_user(
                chat_id=message.from_user.id,
                username=message.from_user.username,
                first_name=message.from_user.first_name,
                last_name=message.from_user.last_name,
                language_code=message.from_user.language_code,
                reffer=reffer,
            )
    except Exception as exc:
        logger.error(
            "New user %s[%s]: %s",
            message.from_user.full_name,
            message.from_user.id,
            exc,
        )
    finally:
        await message.answer(
            text=messages.play,
            # reply_markup=button(),
            parse_mode="HTML",
            reply_markup=button(),
        )