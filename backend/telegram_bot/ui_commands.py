from aiogram import Bot
from aiogram.types import BotCommand, BotCommandScopeAllPrivateChats


async def set_bot_commands(bot: Bot):
    commands = [
        BotCommand(command="start", description="Get play button"),
        BotCommand(command="reflink", description="Get your refferal link"),
        BotCommand(command="channel", description="Get channel link")
    ]
    await bot.set_my_commands(commands=commands, scope=BotCommandScopeAllPrivateChats())
