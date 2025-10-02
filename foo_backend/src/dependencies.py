from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from typing import Annotated

from .user.models import User
from .user.service import Service as UserService

ouath_2_scheme = OAuth2PasswordBearer(tokenUrl="/api/user/auth")

async def get_current_user(token: Annotated[str, Depends(ouath_2_scheme)]) -> User:
    try:
        token_data = UserService.decode_jwt(token, "access")

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