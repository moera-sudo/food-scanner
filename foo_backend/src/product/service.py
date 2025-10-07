#TODO надо сделать сервис для продуктов
"""
Тут должны быть: Функции для роутов пользователей(получение даты + картинки, отдача картинки, вычисление рейтинга и нутри скора): 

"""

from fastapi import UploadFile
from pathlib import Path

import logging
import shutil

from .models import Product, NutriScoreEnum
from .schemas import RatingDataModel

logger = logging.getLogger(__name__)

class Service:

    UPLOADS_DIR = "uploads"
    ROOT_DIR = Path(__file__).resolve().parent.parent / UPLOADS_DIR

    @staticmethod
    def upload_image(upload_file: UploadFile, dir = ROOT_DIR) -> str:

        logger.debug(f"UPLOADS DIRECTORY: {dir}")
        # dir.mkdir(parents=True, exist_ok=True)

        file_path = dir / upload_file.filename
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(upload_file.file, buffer)

        upload_file.close()

        logger.debug(f"RETURNING FILE PATH: {file_path}")
        return f"{file_path}"
    
    
    @staticmethod
    def calculate_nutriscore(data: RatingDataModel) -> NutriScoreEnum:
        """
        Упрощенный аналог Nutri-Score.
        Чем меньше калорий, жира и сахара и больше клетчатки и белка — тем лучше.
        """

        bad_points = (data.calories / 80) + data.fat * 1.5 + data.sugar * 2
        good_points = data.fiber * 2 + data.protein * 1.5

        score = bad_points - good_points



        if score <= 0:
            return NutriScoreEnum.E
        elif score <= 5:
            return NutriScoreEnum.D
        elif score <= 10:
            return NutriScoreEnum.C
        elif score <= 15:
            return NutriScoreEnum.B
        else:
            return NutriScoreEnum.A
        

    @staticmethod
    def calculate_rating_score(data: RatingDataModel) -> float:

        negative_points = (data.calories / 100) + data.fat * 0.5 + data.sugar * 0.8

        positive_points = data.protein * 1.2 + data.fiber * 0.8

        raw_score = 10 - (negative_points * 0.1) + (positive_points * 0.05)
        rating = max(1, min(round(raw_score, 1), 10))  
        return rating

