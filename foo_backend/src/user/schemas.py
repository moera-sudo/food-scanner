from typing import Optional, Literal
from pydantic import BaseModel, Field, field_validator, ValidationInfo


class TokenData(BaseModel):
    sub: str = Field(...)
    exp: Optional[int] = None
    iat : Optional[int] = None
    token_type : Literal['access', 'refresh']

    model_config = {
        'extra': 'forbid'
    }

class Token(BaseModel):
    token: str
    token_type: Literal['access', 'refresh']

class TokensResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: Literal['bearer'] = 'bearer'
    access_token_expire: Optional[int]
    refresh_token_expire: Optional[int]


class AuthRequest(BaseModel):
    email: Optional[str] = None
    username: Optional[str] = None
    data_type: Literal['email', 'username']
    password: str

    @field_validator("email")
    @classmethod
    def check_email(cls, v, info: ValidationInfo):
        if info.data.get("data_type") == "email" and not v:
            raise ValueError("email обязателен, если data_type='email'")
        return v

    @field_validator("username")
    @classmethod
    def check_username(cls, v, info: ValidationInfo):
        if info.data.get("data_type") == "username" and not v:
            raise ValueError("username обязателен, если data_type='username'")
        return v


class RegRequest(BaseModel):
    email: str
    username: str
    password: str
