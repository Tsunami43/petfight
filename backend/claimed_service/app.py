import sys
import os

current_dir = os.path.dirname(__file__)

parent_dir = os.path.abspath(os.path.join(current_dir, os.pardir))
sys.path.append(parent_dir)

from common import Config, Logger
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api import claim
from database import db

logger = Logger.create("App", file=True)
app = FastAPI(
    title="CLAIMED SERVICE",
    version="1.0.0",
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Обычно лучше ограничить список доменов, разрешенных для CORS
    allow_credentials=True,
    allow_methods=["POST", "OPTIONS"],  # Включаем OPTIONS здесь
    allow_headers=["*"],
)
# Подключение роутеров
app.include_router(claim.router)


@app.on_event("startup")
async def startup():
    await db.connect()


@app.on_event("shutdown")
async def shutdown():
    await db.disconnect()


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        app, host=Config.host_service, port=Config.port_service("CLAIMED_SERVICE")
    )
