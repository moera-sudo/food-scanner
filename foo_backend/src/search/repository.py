from ..product.models import Product
from .ml_service import ml_extractor
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import logging

logger = logging.getLogger(__name__)

class SearchRepository:

    @staticmethod
    async def search_by_image(image_bytes: bytes) -> int | None:
        """
        Ищет продукт с самой похожей картинкой.
        """
        # 1. Получаем вектор загруженного фото
        query_vector = ml_extractor.get_vector(image_bytes)
        if not query_vector:
            return None

        # 2. Загружаем все продукты, у которых есть вектор
        # В реальном продакшене тут используют векторные БД (Pinecone, Milvus),
        # но для курсовой проход по всем записям (даже 1000) будет мгновенным.
        products = await Product.filter(image_vector__not_isnull=True).all()
        
        if not products:
            return None

        best_score = -1.0
        best_product_id = None

        # Превращаем query_vector в numpy array 2D
        q_vec = np.array([query_vector])

        for prod in products:
            if not prod.image_vector:
                continue
            
            # Берем вектор из базы
            p_vec = np.array([prod.image_vector])
            
            # Считаем сходство (от 0 до 1, где 1 - идентично)
            score = cosine_similarity(q_vec, p_vec)[0][0]
            
            logger.debug(f"Product {prod.name} similarity: {score}")

            # Если сходство выше текущего максимума
            if score > best_score:
                best_score = score
                best_product_id = prod.id

        # Порог уверенности. Если ниже 0.7 - скорее всего это не то.
        logger.info(f"Best match score: {best_score}")
        if best_score > 0.75: 
            return best_product_id
        
        return None

    # Обычный текстовый поиск
    @staticmethod
    async def search_product_id(query: str) -> int | None:
        product = await Product.filter(name__icontains=query).first()
        return product.id if product else None