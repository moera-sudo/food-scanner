from fastapi import UploadFile, File
from fastapi.exceptions import HTTPException
from fastapi.responses import FileResponse
from tortoise.exceptions import DoesNotExist

from .service import Service as ProductService
from .models import Product
from .schemas import ProductRequest, ProductResponse, RatingDataModel

from ..comments.repository import CommentRepository
from ..comments.schemas import CommentResponse

import logging


logger = logging.getLogger(__name__)



class ProductRepository:


    @staticmethod
    async def create_product(data: ProductRequest, file: UploadFile = File(...)) -> bool:

        try:

            logger.info(f"Getting data: {data}")

            composition_data = RatingDataModel.model_validate(data.model_dump())

            rating_score = ProductService.calculate_rating_score(data=composition_data)
            nutri_score = ProductService.calculate_nutriscore(data=composition_data)
            image_path = ProductService.upload_image(upload_file=file)

            logger.info(f"Product data calculated : {rating_score, nutri_score, image_path}")
        
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
                image_url = image_path
            )

            logger.info(f"Product successfully created: {product.id}")

            return True

        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to create product: {e}"
            )
            
        

    @staticmethod
    async def get_product(product_id: int) -> ProductResponse:
        try:
            # Загружаем продукт вместе с комментариями и автором каждого комментария
            product = await Product.get(id=product_id).prefetch_related("comments__user")

            # Собираем список комментариев
            comments_data = [
                {
                    "id": comment.id,
                    "text": comment.text,
                    "user_id": comment.user.id,          # <-- теперь как в схеме
                    "created_at": comment.created_at,    # <-- добавлено
                }
                for comment in product.comments
            ]


            product_response = ProductResponse.model_validate({
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
                "comments": comments_data,  # вот так
            })

            return product_response

        except DoesNotExist:
            raise HTTPException(
                status_code=404,
                detail="Product not found"
            )

        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to get product: {e}"
            )

        
    
        
    @staticmethod
    async def get_image(product_id: int) -> FileResponse:
        try: 
            product = await Product.get(id=product_id)
            logger.info(f"Returning image: {product.image_url}")

            return FileResponse(product.image_url)
        
        except DoesNotExist:
            raise HTTPException(
                status_code=404,
                detail="Image not found"
            )
        
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to get image: {e}"
            )
            
