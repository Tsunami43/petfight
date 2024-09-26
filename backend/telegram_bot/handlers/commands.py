from aiogram import Router
from aiogram.filters import Command
from aiogram.types import Message
import messages

router = Router()


@router.message(Command("reflink"))
async def start_handler(message: Message):
    await message.answer(messages.get_ref_link(message.from_user.id), parse_mode="HTML")


@router.message(Command("channel"))
async def start_handler(message: Message):
    await message.answer(messages.channel, parse_mode="HTML")
