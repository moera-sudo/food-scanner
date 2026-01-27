from pydantic import BaseModel
from datetime import datetime
from uuid import UUID

class CommentCreate(BaseModel):
    product_id: int
    text: str

class CommentResponse(BaseModel):
    id: int
    user_id: UUID
    username: str
    text: str
    created_at: datetime

    class Config:
        from_attributes = True
