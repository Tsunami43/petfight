from asyncpg import exceptions
from common import DatabaseTemplate, Config, Logger
from models import User


class Database(DatabaseTemplate):
    def __init__(self):
        super().__init__(dsn=Config.dsn, logger=Logger.create("Database", file=True))

    async def add_user(self, user: User):
        insert_telegram_user_query = """
        INSERT INTO telegram_users (chat_id, username, first_name, last_name, language_code)
        VALUES ($1, $2, $3, $4, $5)
        ON CONFLICT (chat_id) DO NOTHING
        RETURNING id;
        """

        select_telegram_user_id_query = (
            "SELECT id FROM telegram_users WHERE chat_id = $1;"
        )

        insert_user_query = """
        INSERT INTO users (telegram_id, balance)
        VALUES ($1, $2)
        ON CONFLICT (telegram_id) DO NOTHING;
        """

        try:
            async with self.pool.acquire() as connection:
                async with connection.transaction():
                    # Вставка в таблицу telegram_users
                    telegram_user_id = await connection.fetchval(
                        insert_telegram_user_query,
                        user.chat_id,
                        user.username,
                        user.first_name,
                        user.last_name,
                        user.language_code,
                    )

                    if not telegram_user_id:
                        # Если запись уже существует, получить id
                        telegram_user_id = await connection.fetchval(
                            select_telegram_user_id_query, user.chat_id
                        )

                    # Вставка в таблицу users
                    await connection.execute(insert_user_query, telegram_user_id, 0)

                    self.logger.info(
                        f"User added successfully: {str(user)} (Telegram ID: {telegram_user_id})"
                    )

        except exceptions.UniqueViolationError as exc:
            self.logger.error(
                f"User with Telegram ID: {user.chat_id} already exists: {str(exc)}"
            )
        except Exception as exc:
            self.logger.error(f"Failed to add user {str(user)}: {str(exc)}")

    async def add_referral(self, referrer_chat_id: int, referral_chat_id: int):
        try:
            result = await self.execute(
                """
                INSERT INTO referrals (referrer_telegram_id, referral_telegram_id)
                SELECT 
                    referrer.id AS referrer_telegram_id,
                    referral.id AS referral_telegram_id
                FROM 
                    telegram_users AS referrer
                    JOIN telegram_users AS referral ON referrer.chat_id = $1 AND referral.chat_id = $2
            """,
                referrer_chat_id,
                referral_chat_id,
            )
            if result == "INSERT 0 1":
                self.logger.info(
                    f"Success: referrer({referrer_chat_id}) -> referral({referral_chat_id})"
                )
            else:
                self.logger.error(
                    f"Invalid referrer({referrer_chat_id})  or referral({referral_chat_id})"
                )
        except exceptions.ForeignKeyViolationError as exc:
            self.logger.error(
                f"Invalid referrer({referrer_chat_id})  or referral({referral_chat_id}): {str(exc)}"
            )
        except exceptions.UniqueViolationError as exc:
            self.logger.error(f"Such a referral link already exists: {str(exc)}")
        except Exception as exc:
            self.logger.error(
                f"Error when executing the request referrer({referrer_chat_id}) -> referral({referral_chat_id}): {str(exc)}"
            )

    async def get_user_info(self, chat_id: int):
        query_user_info = """
        SELECT 
            t.chat_id,
            t.id,
            u.balance,
            u.last_claim_timestamp
        FROM 
            users u
        JOIN 
            telegram_users t ON u.telegram_id = t.id
        WHERE 
            t.chat_id = $1;
        """

        query_tasks = """
        SELECT 
            task_name, 
            task_status
        FROM 
            tasks
        WHERE 
            user_id = (SELECT id FROM users WHERE telegram_id = (SELECT id FROM telegram_users WHERE chat_id = $1));
        """

        query_referrals = """
        SELECT 
            referral.username AS referral_username, 
            r.claimed_tokens
        FROM 
            referrals r
        JOIN 
            telegram_users referral ON r.referral_telegram_id = referral.id
        WHERE 
            r.referrer_telegram_id = (SELECT id FROM telegram_users WHERE chat_id = $1);
        """

        try:
            async with self.pool.acquire() as connection:
                async with connection.transaction():
                    user_info = await connection.fetchrow(query_user_info, chat_id)
                    tasks = await connection.fetch(query_tasks, chat_id)
                    referrals = await connection.fetch(query_referrals, chat_id)
                    if user_info["last_claim_timestamp"] is not None:
                        lct = int((user_info["last_claim_timestamp"]).timestamp())
                    else:
                        lct = user_info["last_claim_timestamp"]
                    if user_info:
                        result = {
                            "user_id": user_info["id"],
                            "user": {
                                "telegram_id": user_info["chat_id"],
                                "balance": user_info["balance"],
                                "last_claim_timestamp": lct,
                                "tasks": [
                                    {
                                        "task_name": task["task_name"],
                                        "task_status": task["task_status"],
                                    }
                                    for task in tasks
                                ],
                                "referrals": [
                                    {
                                        "referral_username": ref["referral_username"],
                                        "claimed_tokens": ref["claimed_tokens"],
                                    }
                                    for ref in referrals
                                ],
                            },
                        }
                        self.logger.info(f"User info retrieved successfully: {result}")
                        return result
                    else:
                        self.logger.info(f"No user found with chat_id: {chat_id}")
                        return None
        except Exception as exc:
            self.logger.error(
                f"Failed to retrieve user info with chat_id: {chat_id}: {str(exc)}"
            )
            return None


db = Database()
