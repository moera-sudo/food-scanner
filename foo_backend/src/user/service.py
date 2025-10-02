from fastapi import HTTPException
from jose import jwt, ExpiredSignatureError
from typing import Optional
from datetime import timedelta, datetime, timezone
from pydantic import ValidationError
from tortoise.exceptions import DoesNotExist
from passlib.context import CryptContext


from .schemas import Token, TokenData
from .settings import auth_Settings as authSettings
from .models import User
from ..core.settings import appSettings as Settings

class Service: 

    pwdContext = CryptContext(schemes="bcrypt", deprecated="auto")
    

    @staticmethod
    def create_jwt(data: TokenData, expires_delta: Optional[timedelta] = None) -> tuple[dict, int]:
        try:
            to_encode = data.model_dump(exclude_unset=True)

            now = datetime.now(timezone.utc)

            if data.token_type == 'refresh':
                expire = now + timedelta(days=authSettings.REFRESH_TOKEN_EXPIRE)
            elif data.token_type == 'access' and expires_delta:
                expire = now + expires_delta
            elif data.token_type == 'access' and not expires_delta:
                expire = now + timedelta(minutes=authSettings.ACCESS_TOKEN_EXPIRE)

            to_encode.update({
                'exp': int(expire.timestamp()),
                'iat': int(now.timestamp()),
                'token_type': data.token_type
            })

        except (ValueError, ValidationError) as e:
            raise HTTPException(
                status_code=500,
                detail=f'Token Data error: {e}'
            )

        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f'Failed to prepare payload: {e}'
            )
        else: 
            try:
                secret_key = authSettings.SECRET_KEY if data.token_type == 'access' else authSettings.REFRESH_SECRET_KEY

                payload = jwt.encode(
                    to_encode,
                    secret_key,
                    algorithm=authSettings.ALGORITHM
                )

                return (payload, int(expire.timestamp())) # It has to be tested
            
            except Exception as e:
                raise HTTPException(
                    status_code=500,
                    detail=f'Failed to create JWT Token: {e}'
                )

    @staticmethod
    def decode_jwt(data: Token) -> Optional[TokenData]:
        try: 
            secret_key = authSettings.SECRET_KEY if data.token_type == 'access' else authSettings.REFRESH_SECRET_KEY

            payload = jwt.decode(
                data.token,
                secret_key,
                algorithms=authSettings.ALGORITHM
            )

            token_data = TokenData(**payload)

            return token_data
        
        except ExpiredSignatureError:
            raise HTTPException(
                status_code=401,
                detail='Token Expired'
            )
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f'Failed to decode token: {e}'
            )
        
    @staticmethod
    def get_password_hash(password: str) -> str:
        return Service.pwdContext.hash(password)
    
    @staticmethod
    def verify_password(password: str, hashed_password: str) -> str:
        return Service.pwdContext.verify(password, hashed_password)


    '''
    Functions with ORM Queries
    '''
    @staticmethod
    async def get_user_by_id(id: str) -> User:
        try:
            user = await User.get(id=id)
            return user
        except DoesNotExist:
            raise HTTPException(
                status_code=404,
                detail='User not found'
            )

    @staticmethod
    async def get_user_by_email(emailStr: str) -> User:
         try:
            user = await User.get(email=emailStr)
            return user
         except DoesNotExist:
             raise HTTPException(
                 status_code=404,
                 detail='User not found'
             )
         except Exception as e:
             raise HTTPException(
                 status_code=500,
                 detail=f'Error while getting user by email: {e}'
             )
    
    @staticmethod
    async def get_user_by_username(usernameStr: str) -> User:
        try:
            user = await User.get(username=usernameStr)
            return user
        except DoesNotExist:
            raise HTTPException(
                status_code=404,
                detail='User not found'
            )
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f'Error while getting user by username: {e}'
            )
        
    @staticmethod
    async def is_unique(emailStr: str, usernameStr: str) -> bool:
        try:
            unique_email = await User.exists(email=emailStr)
            unique_username = await User.exists(username=usernameStr)
            if unique_email:
                return False
            elif unique_username:
                return False
            
            return True
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f'Failed while checking on uniqueness: {e}'
            )