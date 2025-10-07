from fastapi import APIRouter, Query, HTTPException
from .repository import SearchRepository
from .schemas import SearchResponse

router = APIRouter(
    prefix="/search",
    tags=["Search"])

@router.get("/", response_model=SearchResponse)
async def search_product(q: str = Query(..., min_length=1)):
    try:
        product_id = await SearchRepository.search_product_id(q)
        if not product_id:
            raise HTTPException(status_code=404, detail="Product not found")
        return {"id": product_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
