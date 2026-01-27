from fastapi import APIRouter, Query, HTTPException, UploadFile, File
from .repository import SearchRepository
from .schemas import SearchResponse

router = APIRouter(prefix="/search", tags=["Search"])

@router.get("/", response_model=SearchResponse)
async def search_product(q: str = Query(..., min_length=1)):
    product_id = await SearchRepository.search_product_id(q)
    if not product_id:
        raise HTTPException(status_code=404, detail="Product not found")
    return {"id": product_id}

@router.post("/photo", response_model=SearchResponse)
async def search_by_photo(file: UploadFile = File(...)):
    try:
        file_bytes = await file.read()
        
        # Запускаем поиск по вектору
        product_id = await SearchRepository.search_by_image(file_bytes)
        
        if not product_id:
            raise HTTPException(status_code=404, detail="No similar product found")
            
        return {"id": product_id}
        
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Search failed: {e}")