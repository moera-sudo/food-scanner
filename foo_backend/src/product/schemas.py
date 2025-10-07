"""
ProductRequest
ProductResponse


"""
from fastapi import Form
from typing import Optional, Literal
from pydantic import BaseModel, Field, conint

from .models import NutriScoreEnum

class ProductRequest(BaseModel):
    name: str = Field(..., max_length=64)
    description: str = None

    calories: conint(ge=0)
    fat: conint(ge=0)
    protein: conint(ge=0)
    carbs: conint(ge=0)
    sugar: conint(ge=0)
    fiber: conint(ge=0)

class ProductResponse(BaseModel):
    id: int
    name: str
    description: str = None

    calories: int
    fat: int
    protein: int
    carbs: int
    sugar: int
    fiber: int

    rating: float
    nutriscore: NutriScoreEnum

    model_config = {
        "from_attributes": True
    }
    
class RatingDataModel(BaseModel):
    calories: int
    fat: int
    protein: int
    carbs: int
    sugar: int
    fiber: int

