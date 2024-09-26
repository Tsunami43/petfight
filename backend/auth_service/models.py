from typing import Optional
from pydantic import BaseModel


class User(BaseModel):
    chat_id: int
    username: Optional[str] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    language_code: Optional[str] = None
    reffer: Optional[int] = None

    def __str__(self):
        return (
            f"User(chat_id={self.chat_id}, username={self.username}, first_name={self.first_name}, "
            f"last_name={self.last_name}, language_code={self.language_code})"
        )

    def is_refferal(self) -> bool:
        if self.reffer is None:
            return False
        else:
            return True
