from fastapi import APIRouter, Depends

from .repo import UserRepository
from .schemas import Token, TokenData, TokensResponse, AuthRequest, RegRequest, ThemeUpdate
from ..dependencies import get_current_user
from .models import User

router = APIRouter(
    prefix='/user',
    tags=['Auth']
)

@router.post('/reg', status_code=201, response_model=dict)
async def reg_view(data: RegRequest):
    return await UserRepository.reg(data=data)

@router.post('/auth', status_code=200, response_model=TokensResponse)
async def auth_view(data: AuthRequest):
    return await UserRepository.login(data=data)

@router.post('/refresh', status_code=200, response_model=TokensResponse)
async def refresh_view(data: Token):
    return await UserRepository.refresh_token(data=data)

@router.put('/theme', response_model=bool)
async def update_theme_view(data: ThemeUpdate, user: User = Depends(get_current_user)):
    return await UserRepository.update_theme(user=user, mode=data.theme_mode)
