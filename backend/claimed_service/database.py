from asyncpg import exceptions
from common import DatabaseTemplate, Config, Logger
from datetime import datetime
from pytz import timezone, utc

MOSCOW_TZ = timezone("Europe/Moscow")


class Database(DatabaseTemplate):
    def __init__(self):
        super().__init__(dsn=Config.dsn, logger=Logger.create("Database", file=True))

    async def get_user_data(self, telegram_id: int):
        try:
            query = """
                SELECT u.last_claim_timestamp, r.referrer_telegram_id
                FROM users u
                LEFT JOIN referrals r ON u.telegram_id = r.referral_telegram_id
                WHERE u.telegram_id = $1
            """
            row = await self.fetchrow(query, telegram_id)
            return dict(row)
        except Exception as exc:
            self.logger.error(
                f"Error fetching user data for telegram_id {telegram_id}: {exc}"
            )
            return None

    async def update_balance_and_timestamp(self, telegram_id: int, amount: int) -> bool:
        try:
            query = """
                UPDATE users
                SET balance = balance + $1,
                    last_claim_timestamp = (NOW() AT TIME ZONE 'Europe/Moscow')
                WHERE telegram_id = $2
            """
            await self.execute(query, amount, telegram_id)
            self.logger.info(
                f"Balance and last_claim_timestamp updated successfully for telegram_id {telegram_id}"
            )
            return True
        except Exception as exc:
            self.logger.error(
                f"Error updating balance and timestamp for telegram_id {telegram_id}: {exc}"
            )
            return False

    async def update_reffer_balance(
        self, referrer_telegram_id, referral_telegram_id, tokens
    ):
        try:
            query = """
                UPDATE referrals
                SET claimed_tokens = claimed_tokens + $1
                WHERE referrer_telegram_id = $2 AND referral_telegram_id = $3
            """
            await self.execute(
                query,
                tokens,
                referrer_telegram_id,
                referral_telegram_id,
            )
            self.logger.info(
                f"Claimed tokens added successfully for referrer {referrer_telegram_id} and referral {referral_telegram_id}"
            )
        except Exception as exc:
            self.logger.error(
                f"Error adding claimed tokens for referrer {referrer_telegram_id} and referral {referral_telegram_id}: {exc}"
            )


db = Database()
