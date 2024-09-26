from fastapi import APIRouter, HTTPException
from common import Logger
from database import db
from models import User

logger = Logger.get("App")
router = APIRouter()


@router.post("/register")
async def create_user(user: User):
    try:
        await db.add_user(user)
        if user.is_refferal():
            await db.add_referral(user.reffer, user.chat_id)
        return {"status": "created", "user": user.chat_id}
    except Exception as exc:
        raise HTTPException(status_code=500, detail="Error creating user")
