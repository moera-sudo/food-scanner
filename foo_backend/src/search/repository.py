from ..product.models import Product

class SearchRepository:

    @staticmethod
    async def search_product_id(query: str) -> int | None:
        try:
            product = await Product.filter(name__icontains=query).first()
            if product:
                return product.id
            return None
        except Exception as e:
            raise Exception(f"Failed to search product: {e}")
