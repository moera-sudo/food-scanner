from typing import List
from collections import Counter
from ..product.models import Product, NutriScoreEnum

class AnalyticsService:

    @staticmethod
    def calculate_stats(products: List[Product]) -> dict:
        total_count = len(products)
        if total_count == 0:
            return {
                "total_scans": 0,
                "average_score": 0,
                "nutriscore_distribution": {k.value: 0 for k in NutriScoreEnum},
                "avg_calories": 0,
                "avg_protein": 0,
                "avg_fat": 0,
                "avg_sugar": 0,
                "verdict": "No data"
            }

        # Сбор данных
        total_rating = 0
        total_cal = 0
        total_prot = 0
        total_fat = 0
        total_sugar = 0
        
        scores = []

        for p in products:
            total_rating += p.rating
            total_cal += p.calories
            total_prot += p.protein
            total_fat += p.fat
            total_sugar += p.sugar
            
            # Сохраняем NutriScore строкой
            scores.append(p.nutriscore.value if hasattr(p.nutriscore, 'value') else str(p.nutriscore))

        # Подсчет распределения (сколько A, B, C...)
        score_counts = Counter(scores)
        # Заполняем нулями отсутствующие категории для красивого графика
        distrib = {k.value: score_counts.get(k.value, 0) for k in NutriScoreEnum}

        # Вердикт на основе самой частой категории
        most_common_score = score_counts.most_common(1)[0][0] if scores else "E"
        verdict_map = {
            "A": "Excellent Diet! 🥗",
            "B": "Good Balance 🥦",
            "C": "Moderate 🥪",
            "D": "Watch out 🍔",
            "E": "Unhealthy 🍩"
        }

        return {
            "total_scans": total_count,
            "average_score": round(total_rating / total_count, 1),
            "nutriscore_distribution": distrib,
            "avg_calories": int(total_cal / total_count),
            "avg_protein": int(total_prot / total_count),
            "avg_fat": int(total_fat / total_count),
            "avg_sugar": int(total_sugar / total_count),
            "verdict": verdict_map.get(most_common_score, "Unknown")
        }