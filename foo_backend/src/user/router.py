from fastapi import APIRouter

from .repo import UserRepository
from .schemas import Token, TokenData, TokensResponse, AuthRequest, RegRequest

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


