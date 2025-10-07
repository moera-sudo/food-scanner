from tortoise.exceptions import DoesNotExist
from fastapi import HTTPException
from typing import List


from .models import Comment
from ..user.models import User  
from ..product.models import Product

class CommentRepository:

    @staticmethod
    async def create_comment(user: User, product_id: int, text: str) -> bool:
        try:
            await Comment.create(user=user, product_id=product_id, text=text)
            return True
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to create comment: {e}")

    @staticmethod
    async def get_comments_for_product(product_id: int) -> List[dict]:
        try:
            comments = await Comment.filter(product_id=product_id).values(
                "id", "user_id", "text", "created_at"
            )
            return list(comments)
        except DoesNotExist:
            return []
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to get comments: {e}")
