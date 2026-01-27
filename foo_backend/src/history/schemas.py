from pydantic import BaseModel
from ..product.models import NutriScoreEnum

class HistoryItemResponse(BaseModel):
    id: int
    name: str
    image_url: str 
    nutriscore: NutriScoreEnum
    calories: int