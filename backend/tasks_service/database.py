from common import DatabaseTemplate, Config, Logger


class Database(DatabaseTemplate):
    def __init__(self):
        super().__init__(dsn=Config.dsn, logger=Logger.create("Database", file=True))

    async def get_task_info(self, task_name: str, telegram_id: int):
        try:

            # Получение user_id из таблицы users по telegram_id
            user_id_query = """
                SELECT u.id
                FROM users u
                JOIN telegram_users tu ON u.telegram_id = tu.id
                WHERE tu.id = $1
            """
            user_id = await self.fetchval(user_id_query, telegram_id)

            if user_id is None:
                self.logger.warning("User with telegram_id %s not found.", telegram_id)
                return None

            # Получение id и task_status из таблицы tasks по user_id и task_name
            tasks_query = """
                SELECT id, task_status
                FROM tasks
                WHERE user_id = $1 AND task_name = $2
            """
            tasks = await self.fetchrow(tasks_query, user_id, task_name)
            tasks = dict(tasks)
            tasks["user_id"] = user_id
            return tasks

        except Exception as exc:
            self.logger.error("Database error occurred: %s", str(exc))
            return None

    async def update_status_task(
        self, task_id: int, new_status: int, user_id: int, tokens: int
    ) -> bool:
        try:
            async with self.pool.acquire() as connection:
                async with connection.transaction():
                    # Обновление статуса задания в таблице tasks
                    update_task_query = """
                        UPDATE tasks
                        SET task_status = $1
                        WHERE id = $2 AND user_id = $3
                    """
                    self.logger.debug("Updating task status for task_id: %s", task_id)
                    await connection.execute(
                        update_task_query, new_status, task_id, user_id
                    )

                    # Обновление баланса пользователя в таблице users
                    update_balance_query = """
                        UPDATE users
                        SET balance = balance + $1
                        WHERE id = $2
                    """
                    self.logger.debug("Updating user balance for user_id: %s", user_id)
                    await connection.execute(update_balance_query, tokens, user_id)
                    return True

        except Exception as e:
            self.logger.error("Database error occurred: %s", e)
            return False


db = Database()
