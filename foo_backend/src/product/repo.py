from fastapi import UploadFile, File
from fastapi.exceptions import HTTPException
from fastapi.responses import FileResponse
from tortoise.exceptions import DoesNotExist

from .service import Service as ProductService
from .models import Product
from .schemas import ProductRequest, RatingDataModel

# Импорт нашего ML экстрактора
from ..search.ml_service import ml_extractor 

import logging

logger = logging.getLogger(__name__)

class ProductRepository:

    @staticmethod
    async def create_product(data: ProductRequest, file: UploadFile = File(...)) -> bool:
        try:
            # 1. Считываем файл для ML
            file_bytes = await file.read()
            # Возвращаем каретку в начало, чтобы сохранение файла сработало корректно
            await file.seek(0)
            
            # 2. Генерируем вектор (если ML сервис загружен)
            vector = ml_extractor.get_vector(file_bytes)

            logger.info(f"Getting data: {data}")

            composition_data = RatingDataModel.model_validate(data.model_dump())

            rating_score = ProductService.calculate_rating_score(data=composition_data)
            nutri_score = ProductService.calculate_nutriscore(data=composition_data)
            image_path = ProductService.upload_image(upload_file=file)

            logger.info(f"Product data calculated. Vector length: {len(vector)}")
        
            product = await Product.create(
                name = data.name,
                description = data.description,
                calories = data.calories,
                fat = data.fat,
                protein=data.protein,
                carbs = data.carbs,
                sugar = data.sugar,
                fiber = data.fiber,
                rating = rating_score,
                nutriscore = nutri_score,
                image_url = image_path,
                image_vector = vector # Сохраняем вектор
            )

            logger.info(f"Product successfully created: {product.id}")

            return True

        except Exception as e:
            logger.error(f"Failed to create product: {e}", exc_info=True)
            raise HTTPException(
                status_code=500,
                detail=f"Failed to create product: {e}"
            )
            
    # ВОТ ЭТОТ МЕТОД, КОТОРОГО НЕ ХВАТАЛО
    @staticmethod
    async def get_product(product_id: int) -> dict:
        try:
            # Загружаем продукт вместе с комментариями и автором каждого комментария
            product = await Product.get(id=product_id).prefetch_related("comments__user")

            # Собираем список комментариев вручную
            comments_data = [
                {
                    "id": comment.id,
                    "text": comment.text,
                    "user_id": comment.user.id,
                    "username": comment.user.username, # Достаем имя
                    "created_at": comment.created_at,
                }
                for comment in product.comments
            ]
            
            # Сортируем: новые сверху
            comments_data.sort(key=lambda x: x['created_at'], reverse=True)

            # Формируем ответ (словарь, который Pydantic превратит в JSON)
            return {
                "id": product.id,
                "name": product.name,
                "description": product.description,
                "calories": product.calories,
                "fat": product.fat,
                "protein": product.protein,
                "carbs": product.carbs,
                "sugar": product.sugar,
                "fiber": product.fiber,
                "rating": product.rating,
                "nutriscore": product.nutriscore,
                "image_url": product.image_url, # Важно для фронта
                "comments": comments_data,
            }

        except DoesNotExist:
            raise HTTPException(
                status_code=404,
                detail="Product not found"
            )

        except Exception as e:
            logger.error(f"Failed to get product: {e}", exc_info=True)
            raise HTTPException(
                status_code=500,
                detail=f"Failed to get product: {e}"
            )

    @staticmethod
    async def get_image(product_id: int) -> FileResponse:
        try: 
            product = await Product.get(id=product_id)
            # logger.info(f"Returning image: {product.image_url}")
            return FileResponse(product.image_url)
        
        except DoesNotExist:
            raise HTTPException(status_code=404, detail="Image not found")
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to get image: {e}")