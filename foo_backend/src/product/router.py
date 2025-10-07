from fastapi import APIRouter, UploadFile, File, Form

from .repo import ProductRepository
from .schemas import ProductResponse, ProductRequest

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
async def get_product_view(product_id: int):
    return await ProductRepository.get_product(product_id=product_id)

@router.get('/get/image/{product_id}', status_code=200)
async def get_product_image_view(product_id: int):
    return await ProductRepository.get_image(product_id=product_id)