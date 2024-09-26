import asyncpg
from logging import Logger
from asyncpg import Connection, Pool

class DatabaseTemplate:
    def __init__(self, dsn: str, logger: Logger):
        self.dsn = dsn
        self.pool: Pool = None
        self.logger = logger

    async def connect(self):
        try:
            self.pool = await asyncpg.create_pool(self.dsn)
            self.logger.info("Success")
        except Exception as exc:
            self.logger.error(exc)

    async def disconnect(self):
        try:
            if self.pool:
                await self.pool.close()
            self.logger.info("Success")
        except Exception as exc:
            self.logger.error(exc)

    async def execute(self, query: str, *args):
        async with self.pool.acquire() as connection:
            return await connection.execute(query, *args)

    async def fetch(self, query: str, *args):
        async with self.pool.acquire() as connection:
            return await connection.fetch(query, *args)

    async def fetchrow(self, query: str, *args):
        async with self.pool.acquire() as connection:
            return await connection.fetchrow(query, *args)

    async def fetchval(self, query: str, *args):
        async with self.pool.acquire() as connection:
            return await connection.fetchval(query, *args)