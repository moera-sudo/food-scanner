import pytesseract
from PIL import Image
from io import BytesIO
from fastapi import UploadFile
import logging
import re

logger = logging.getLogger(__name__)

class ImageSearchService:
    
    @staticmethod
    def extract_text_from_image(file_bytes: bytes) -> list[str]:
        """
        Принимает байты изображения, возвращает список найденных ключевых слов.
        """
        try:
            image = Image.open(BytesIO(file_bytes))
            
            # Используем Tesseract для извлечения текста
            # lang='eng+rus' если нужны оба языка, но на сервере должны быть языковые пакеты.
            # По дефолту 'eng' работает неплохо для брендов.
            text = pytesseract.image_to_string(image)
            
            logger.info(f"OCR Raw Text: {text}")
            
            # Очистка текста: убираем спецсимволы, оставляем только буквы
            clean_text = re.sub(r'[^a-zA-Zа-яА-Я0-9\s]', '', text)
            
            # Разбиваем на слова
            words = clean_text.split()
            
            # Фильтруем: берем слова длиннее 3 символов (чтобы убрать предлоги и мусор)
            keywords = [w for w in words if len(w) > 3]
            
            return keywords
        except Exception as e:
            logger.error(f"OCR Error: {e}")
            return []