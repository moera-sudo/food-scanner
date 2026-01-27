from pydantic import BaseModel
from typing import Dict

class AnalyticsResponse(BaseModel):
    total_scans: int
    average_score: float # Средний рейтинг (1-100 или 1-10)
    
    # Распределение NutriScore: {"A": 5, "B": 2, "E": 10}
    nutriscore_distribution: Dict[str, int] 
    
    # Средние показатели (анализ диеты пользователя)
    avg_calories: int
    avg_protein: int
    avg_fat: int
    avg_sugar: int
    
    verdict: str # Текстовый вывод, например "Healthy Eater"