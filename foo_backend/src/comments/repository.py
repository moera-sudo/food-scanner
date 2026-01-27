from tortoise.exceptions import DoesNotExist
from fastapi import HTTPException
from typing import List

from .models import Comment
from ..user.models import User  

class CommentRepository:

    @staticmethod
    async def create_comment(user: User, product_id: int, text: str) -> bool:
        try:
            # Создаем комментарий
            await Comment.create(user=user, product_id=product_id, text=text)
            return True
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to create comment: {e}")

    @staticmethod
    async def get_comments_for_product(product_id: int) -> List[dict]:
        try:
            # Используем select_related, чтобы сразу достать данные юзера (username)
            comments = await Comment.filter(product_id=product_id).select_related("user").order_by("-created_at")
            
            # Формируем список словарей для Pydantic
            result = []
            for c in comments:
                result.append({
                    "id": c.id,
                    "user_id": c.user.id,
                    "username": c.user.username, # Берем имя из связанной модели
                    "text": c.text,
                    "created_at": c.created_at
                })
            return result
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to get comments: {e}")