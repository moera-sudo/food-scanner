from pydantic import BaseModel

class HistoryItemResponse(BaseModel):
    id: int
    name: str
