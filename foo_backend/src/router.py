from fastapi import APIRouter
from datetime import datetime, timedelta, timezone

import logging

from .user.router import router as AuthRouter
from .product.router import router as ProductRouter
from .history.router import router as HistoryRouter
from .search.router import router as SearchRouter
from .comments.router import router as CommentRouter

logger = logging.getLogger(__name__)


router = APIRouter(prefix="/api", tags=['api'])


@router.get("/ping")
async def ping_response():
    logger.info("Request to server")
    pong = "pong"
    now = datetime.now(timezone.utc)

    return {
        "pong":pong,
        "time":now
    }

router.include_router(AuthRouter)
router.include_router(ProductRouter)
router.include_router(HistoryRouter)
router.include_router(SearchRouter)
router.include_router(CommentRouter)