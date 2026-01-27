from fastapi.exceptions import HTTPException
from tortoise.exceptions import DoesNotExist

from .models import History
from ..user.models import User
import logging

logger = logging.getLogger(__name__)

class HistoryRepository:

    @staticmethod
    async def create_history_note(user: User, product_id: int) -> bool:
        try:
            # 1. Проверяем, смотрел ли пользователь этот продукт ранее
            # Если да - удаляем старую запись, чтобы новая встала в начало списка (Order by created_at desc)
            existing_note = await History.filter(user=user, product_id=product_id).first()
            if existing_note:
                await existing_note.delete()

            # 2. Создаем новую запись
            await History.create(user=user, product_id=product_id)
            
            logger.info(f"History updated for user {user.id}, product {product_id}")
            return True
        
        except Exception as e:
            logger.error(f"Failed to create history note: {e}")
            # Возвращаем False, но не крашим запрос
            return False
        
    @staticmethod 
    async def get_history_list(user: User) -> list:
        try:
            # Загружаем историю вместе с продуктами, сортируем: новые сверху
            history_items = await History.filter(user=user)\
                .select_related("product")\
                .order_by("-created_at")\
                .all()

            result = []
            for item in history_items:
                prod = item.product
                result.append({
                    "id": prod.id,
                    "name": prod.name,
                    # Проверяем, есть ли url, иначе пустая строка
                    "image_url": prod.image_url if prod.image_url else "",
                    "nutriscore": prod.nutriscore,
                    "calories": prod.calories
                })

            return result
        
        except Exception as e:
            logger.error(f"Error getting history: {e}")
            raise HTTPException(
                status_code=500,
                detail=f"Failed to get history list: {e}"
            )