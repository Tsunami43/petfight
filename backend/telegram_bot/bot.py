import asyncio
import sys
import os

current_dir = os.path.dirname(__file__)

parent_dir = os.path.abspath(os.path.join(current_dir, os.pardir))
sys.path.append(parent_dir)

from database import db
from common import Logger, Config


logger = Logger.create("Telegram", file=True)


from aiogram import Bot, Dispatcher
from handlers import routers
from ui_commands import set_bot_commands
from provider import service_provider

bot = Bot(Config.telegram_token)
dp = Dispatcher()


async def run():
    try:
        await db.connect()
        await bot.delete_webhook(drop_pending_updates=True)
        await set_bot_commands(bot)
        dp.include_routers(*routers)
        logger.info("Starting bot...")
        await dp.start_polling(bot, allowed_updates=dp.resolve_used_update_types())
    except Exception as exc:
        logger.critical(exc)
    finally:
        logger.info("Stopping bot...")
        await bot.session.close()
        await db.disconnect()
        await service_provider.close()


if __name__ == "__main__":
    asyncio.run(run())
