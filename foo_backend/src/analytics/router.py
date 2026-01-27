from fastapi import APIRouter, Depends
from ..user.models import User
from ..dependencies import get_current_user
from ..history.models import History
from .schemas import AnalyticsResponse
from .service import AnalyticsService

router = APIRouter(prefix="/analytics", tags=["Analytics"])

@router.get("/", response_model=AnalyticsResponse)
async def get_analytics(user: User = Depends(get_current_user)):
    # Получаем все продукты из истории пользователя
    history_items = await History.filter(user=user).select_related("product").all()
    
    # Извлекаем сами объекты продуктов
    products = [h.product for h in history_items]
    
    # Считаем статистику в сервисе (чистый Python код)
    stats = AnalyticsService.calculate_stats(products)
    
    return stats