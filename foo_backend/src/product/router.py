from fastapi import APIRouter, UploadFile, File, Form, Depends
from typing import Annotated, Optional
import logging

from .repo import ProductRepository
from .schemas import ProductResponse, ProductRequest

from ..history.repo import HistoryRepository
from ..user.models import User
from ..dependencies import get_current_user_optional

# Настраиваем логгер
logger = logging.getLogger(__name__)

router = APIRouter(
    prefix='/product',
    tags=['Products']
)

@router.post('/new', status_code=201, response_model=bool)
async def new_product_view(
    name: str = Form(...),
    description: str = Form(...),
    calories: int = Form(...),
    fat: int = Form(...),
    protein: int = Form(...),
    carbs: int = Form(...),
    sugar: int = Form(...),
    fiber: int = Form(...),
    file: UploadFile = File(...),
):
    product_data_dict = {
        "name": name,
        "description": description if description else None,
        "calories": calories,
        "fat": fat,
        "protein": protein,
        "carbs": carbs,
        "sugar": sugar,
        "fiber": fiber,
    }
    data: ProductRequest = ProductRequest(**product_data_dict)
    return await ProductRepository.create_product(data=data, file=file)

@router.get('/get/{product_id}', status_code=200, response_model=ProductResponse)
async def get_product_view(
    product_id: int, 
    current_user: Annotated[Optional[User], Depends(get_current_user_optional)]
):
    # 1. Получаем продукт (возвращается dict)
    product_dict = await ProductRepository.get_product(product_id=product_id)

    # 2. Если пользователь авторизован, сохраняем в историю
    if current_user:
        try:
            # Важно: product_dict - это словарь, берем id по ключу
            pid = product_dict['id']
            logger.info(f"[HISTORY] Adding product {pid} to history for user {current_user.username}")
            
            await HistoryRepository.create_history_note(
                user=current_user, 
                product_id=pid
            )
        except Exception as e:
            logger.error(f"[HISTORY] Failed to save history: {e}")
            # Не прерываем выполнение, если история сломалась, просто логируем

    return product_dict

@router.get('/get/image/{product_id}', status_code=200)
async def get_product_image_view(product_id: int):
    return await ProductRepository.get_image(product_id=product_id)