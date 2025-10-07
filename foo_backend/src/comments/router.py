from fastapi import APIRouter, Depends, HTTPException
from .schemas import CommentCreate, CommentResponse
from .repository import CommentRepository
from ..dependencies import get_current_user  # твой текущий способ получения юзера

router = APIRouter(prefix="/comments", tags=["Comments"])

@router.post("/new", response_model=bool)
async def create_comment(data: CommentCreate, user=Depends(get_current_user)):
    if not user:
        raise HTTPException(status_code=401, detail="Authentication required")
    return await CommentRepository.create_comment(user=user, product_id=data.product_id, text=data.text)
