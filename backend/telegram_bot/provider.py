import httpx
import asyncio
import json
from typing import Optional
from common import Config, Logger


class ServiceProvider:
    def __init__(self):
        self.base_url: str = (
            f"http://{Config.host_service}:{Config.port_service('AUTH_SERVICE')}"
        )
        self.client = httpx.AsyncClient(timeout=5)
        self.logger = Logger.create("Provider", file=True)
        self.logger.info("Success")

    async def close(self):
        await self.client.aclose()
        self.logger.info("Success")

    async def register_user(
        self,
        chat_id: int,
        username: Optional[str] = None,
        first_name: Optional[str] = None,
        last_name: Optional[str] = None,
        language_code: Optional[str] = None,
        reffer: Optional[int] = None,
    ):
        try:
            if chat_id is None:
                raise ValueError("chat_id must be provided")

            url = f"{self.base_url}/register"
            headers = {"Content-Type": "application/json"}
            data = {
                "chat_id": chat_id,
                "username": username,
                "first_name": first_name,
                "last_name": last_name,
                "language_code": language_code,
                "reffer": reffer,
            }

            response = await self.client.post(url, json=data, headers=headers)

            response.raise_for_status()  # Raise an exception for non-200 responses

            self.logger.info(f"Register user {chat_id} success")
        except httpx.HTTPStatusError as e:
            self.logger.error(f"Register user {chat_id} error: {e}")


service_provider = ServiceProvider()
