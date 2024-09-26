from common import DatabaseTemplate, Config, Logger


class Database(DatabaseTemplate):
    def __init__(self):
        super().__init__(dsn=Config.dsn, logger=Logger.create("Database", file=True))

    async def user_exists(self, chat_id: int) -> bool:
        try:
            # SQL-запрос для проверки наличия пользователя
            check_user_query = """
            SELECT id FROM telegram_users WHERE chat_id = $1;
            """
            # Выполнение запроса
            if await self.fetchval(check_user_query, chat_id) is None:
                return False
            else:
                return True
        except Exception as exc:
            self.logger.error(exc)
            return False


db = Database()
