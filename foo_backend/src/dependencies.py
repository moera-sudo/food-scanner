from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from typing import Annotated, Optional

from .user.models import User
from .user.service import Service as UserService
from .user.schemas import Token

import logging

ouath_2_scheme = OAuth2PasswordBearer(tokenUrl="/api/user/auth", auto_error=False)
logger = logging.getLogger(__name__)

async def get_current_user(token: Annotated[str, Depends(ouath_2_scheme)]) -> User:
    try:
        access_token = {
            "token": token,
            "token_type": "access"
        }
        model_access_token = Token(**access_token)
        token_data = UserService.decode_jwt(model_access_token)
        
        if token_data is None:
            raise HTTPException(
                status_code=401,
                detail="Could not validate credentials"
            )
        
        user = await UserService.get_user_by_id(id=token_data.sub)

        return user
    except Exception as e:
        raise HTTPException(
            status_code=401,
            detail=f"Failed to get current user: {e}"
        )
    
async def get_current_user_optional(token: Annotated[Optional[str], Depends(ouath_2_scheme)]) -> Optional[User]:

    logger.info("Attempt to get current user by optional method")
    if not token:
        logger.info("No token provided, returning None")
        return None

    try:
        access_token = {
            "token": token,
            "token_type": "access"
        }
        model_access_token = Token(**access_token)
        token_data = UserService.decode_jwt(model_access_token)
        if not token_data:
            return None

        user = await UserService.get_user_by_id(id=token_data.sub)
        return user
    except Exception as e:
        logger.error(f"Failed to get optional current user: {e}")