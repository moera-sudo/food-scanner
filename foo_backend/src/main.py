from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from contextlib import asynccontextmanager
from tortoise import Tortoise
from pathlib import Path

import uvicorn
import logging

from .core.settings import appSettings
from .core.config import TORTOISE_ORM, setup_logging
from .router import router

logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):

    setup_logging(debug=appSettings.DEBUG)

    logger.info("Starting app initialization")


    await Tortoise.init(config=TORTOISE_ORM)

    if appSettings.DEBUG:
        logger.info("DEBUG mode is active. Generating schemas..")
        await Tortoise.generate_schemas()
        logger.info("Schemas are generated")

    logger.info("App startup completed")

    yield

    logger.info("Shutting down application")
    await Tortoise.close_connections()
    logger.info("DB connection closed")
    logger.info("App shutdown completed")

app = FastAPI(
    title=appSettings.APP_NAME,
    description=appSettings.APP_DESC,
    version=appSettings.APP_VERSION,
    docs_url="/api/docs" if appSettings.DEBUG else None,
    redoc_url="/api/redoc" if appSettings.DEBUG else None,
    lifespan=lifespan
)

UPLOADS_DIR = Path(__file__).resolve().parent / "uploads"
UPLOADS_DIR.mkdir(parents=True, exist_ok=True)
app.mount("/uploads", StaticFiles(directory=UPLOADS_DIR), name="uploads")
logger.info("Uploads dir mounted")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods="*",
    allow_headers=["*"]
)

app.include_router(router)