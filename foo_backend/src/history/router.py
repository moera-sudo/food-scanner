from fastapi import APIRouter, Depends

from .repo import HistoryRepository
from .schemas import HistoryItemResponse

from ..user.models import User 
from ..dependencies import get_current_user


router = APIRouter(
    prefix='/history',
    tags=['History']
)

@router.get('/get', status_code=200, response_model=list[HistoryItemResponse])
async def history_get_view(current_user: User = Depends(get_current_user)):
    return await HistoryRepository.get_history_list(user=current_user)