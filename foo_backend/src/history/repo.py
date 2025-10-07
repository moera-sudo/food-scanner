from fastapi.exceptions import HTTPException
from tortoise.exceptions import DoesNotExist

from .models import History

from ..product.models import Product
from ..user.models import User


import logging


logger = logging.getLogger(__name__)


class HistoryRepository:

    @staticmethod
    async def create_history_note(user: User, product: int) -> bool:
 
        try:

            logger.info(f"Creating new history note for User: {user.username}. {product} - has been viewed")

            history_note = await History.create(user_id=user.id, product_id=product)

            logger.info(f"History Note successfully created: {history_note.id}")

            return True
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to create history note: {e}"
            )
        
    @staticmethod 
    async def get_history_list(user: User) -> list:
        try:

            logger.info("Attempt to get history list")

            history_ids = await History.filter(user_id = user.id).values_list("product_id", flat=True)

            logger.info(f"Got list of history ids: {history_ids}")

            products_list = await Product.filter(id__in = history_ids).values("id", "name")
            logger.info(f"Got products {products_list}")

            return list(products_list)
        
        except DoesNotExist:
            raise HTTPException(
                status_code=404,
                detail='History note not found'
            )
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to get history list: {e}"
            )