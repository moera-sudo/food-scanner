import json
import logging
from fastapi.exceptions import HTTPException
from jose import JWTError

from .service import Service as UserService
from .settings import auth_Settings as authSettings
from ..core.settings import appSettings as appSettings
from .models import User
from ..dependencies import get_current_user
from .schemas import Token, TokenData, TokensResponse, AuthRequest, RegRequest

logger = logging.getLogger(__name__)

class UserRepository:

    @staticmethod
    async def login(data: AuthRequest) -> TokensResponse:
        try:
            logger.info(f"Login attempt: type={data.data_type}, value={(data.email or data.username)}")

            user = None
            value_type = data.data_type
            logger.info(f"Attempt to fetch user, value_type: {value_type}")
            if value_type == 'email':
                user = await UserService.get_user_by_email(data.email)
                logger.debug(f"User fetched by email: {user}")
            
            if value_type == 'username': 
                user = await UserService.get_user_by_username(data.username)
                logger.debug(f"User fetched by username: {user}")

            if not user:
                logger.warning(f"User not found: {data.username or data.email}")
                raise HTTPException(
                    status_code=404,
                    detail="User not found"
                )                
            
            if not UserService.verify_password(data.password, user.password):
                logger.warning(f"Incorrect password for user id={user.id if user else 'None'}")
                raise HTTPException(
                    status_code=401,
                    detail='Incorrect password'
                )
            
        except Exception as e:
            logger.error(f"Login failed: {e}", exc_info=True)
            raise HTTPException(
                status_code=500,
                detail=f'Exception: {e}'
            )
        
        else:
            try:
                logger.info(f"Generating tokens for user id={user.id}")

                access_token_data = {"sub": str(user.id), "token_type": "access"}
                access_jwt, access_expire = UserService.create_jwt(TokenData(**access_token_data))

                refresh_token_data = {"sub": str(user.id), "token_type": "refresh"}
                refresh_jwt, refresh_expire = UserService.create_jwt(TokenData(**refresh_token_data))

                payload = {
                    "access_token": access_jwt,
                    "refresh_token": refresh_jwt,
                    "access_token_expire": access_expire ,
                    "refresh_token_expire": refresh_expire
                }

                logger.debug(f"Tokens generated for user id={user.id}")
                return TokensResponse(**payload)
            except Exception as e:
                logger.error(f"Token generation failed for user id={user.id}: {e}", exc_info=True)
                raise HTTPException(
                    status_code=500,
                    detail=f"Failed: {e}")

    @staticmethod
    async def reg(data: RegRequest) -> dict:
        try:
            logger.info(f"Registration attempt: email={data.email}, username={data.username}")

            if not await UserService.is_unique(emailStr=data.email, usernameStr=data.username):
                logger.warning(f"Non-unique email or username: {data.email}, {data.username}")
                return {"response": False, "message": "Non-unique email or username"}
            
            hashed_password = UserService.get_password_hash(data.password)
            logger.debug("Password hashed successfully")

            user = await User.create(
                username=data.username,
                email=data.email,
                password=hashed_password
            )

            logger.info(f"User created successfully: id={user.id}")
            return {"response": True, "message": "User successfully created"}
        
        except Exception as e:
            logger.error(f"User registration failed: {e}", exc_info=True)
            raise HTTPException(
                status_code=500,
                detail=f"Failed to create new User: {e}"
            )

    @staticmethod   
    async def refresh_token(data: Token) -> TokensResponse:
        try:
            
            if data.token_type != 'refresh':
                raise HTTPException(
                    status_code=400,
                    detail='Not-refresh token cannot be used as refresh'
                )

            logger.info("Refreshing token")

            token_data = UserService.decode_jwt(data)
            logger.debug(f"Token decoded: sub={token_data.sub}, type={token_data.token_type}")

            user = await UserService.get_user_by_id(token_data.sub)
            logger.debug(f"Fetched user for refresh: id={user.id if user else 'None'}")

            access_token_data = {"sub": str(user.id), "token_type": "access"}
            access_jwt, access_expire = UserService.create_jwt(TokenData(**access_token_data))

            refresh_token_data = {"sub": str(user.id), "token_type": "refresh"}
            refresh_jwt, refresh_expire = UserService.create_jwt(TokenData(**refresh_token_data))

            payload = {
                "access_token": access_jwt,
                "refresh_token": refresh_jwt,
                "access_token_expire": access_expire,
                "refresh_token_expire": refresh_expire
            }

            logger.info(f"Tokens refreshed for user id={user.id}")
            return TokensResponse(**payload)
        
        except Exception as e:
            logger.error(f"Token refresh failed: {e}", exc_info=True)
            raise HTTPException(
                status_code=500,
                detail=f'Failed: {e}')
