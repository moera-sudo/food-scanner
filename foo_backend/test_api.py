import requests
from PIL import Image
import io

# URL твоего API
BASE_URL = "http://127.0.0.1:8000/api"

def create_dummy_image(color='red'):
    """Создает простое цветное изображение в памяти"""
    img = Image.new('RGB', (224, 224), color=color)
    img_byte_arr = io.BytesIO()
    img.save(img_byte_arr, format='JPEG')
    img_byte_arr.seek(0)
    return img_byte_arr

def test_flow():
    print("🚀 Начинаем тест ML поиска...")

    # 1. Генерируем тестовую картинку (Красный квадрат)
    # Представим, что это "Красное Яблоко"
    image_data = create_dummy_image(color='red')

    # 2. Создаем продукт
    print("\n[1] Создаем продукт 'Red Apple'...")
    
    product_data = {
        "name": "Red Apple Test",
        "description": "Tasty red apple",
        "calories": 52,
        "fat": 0,
        "protein": 0,
        "carbs": 14,
        "sugar": 10,
        "fiber": 2
    }
    
    # Файлы для отправки (ключ 'file' должен совпадать с FastAPI аргументом)
    files = {'file': ('apple.jpg', image_data, 'image/jpeg')}

    try:
        response = requests.post(f"{BASE_URL}/product/new", data=product_data, files=files)
        
        if response.status_code == 201 or response.status_code == 200:
            print("✅ Продукт успешно создан! Вектор должен быть сохранен в БД.")
        else:
            print(f"❌ Ошибка создания: {response.status_code} - {response.text}")
            return
    except Exception as e:
        print(f"❌ Не удалось подключиться к серверу: {e}")
        return

    # 3. Тестируем поиск по ТОЙ ЖЕ картинке
    print("\n[2] Ищем продукт по той же картинке...")
    
    # Перематываем байты изображения в начало, чтобы отправить снова
    image_data.seek(0)
    files_search = {'file': ('search_query.jpg', image_data, 'image/jpeg')}
    
    response_search = requests.post(f"{BASE_URL}/search/photo", files=files_search)
    
    if response_search.status_code == 200:
        data = response_search.json()
        print(f"✅ УСПЕХ! Найден продукт ID: {data['id']}")
        print("Система узнала картинку!")
    else:
        print(f"❌ Ничего не найдено (или ошибка): {response_search.status_code} - {response_search.text}")

    # 4. Тестируем поиск по СОВЕРШЕННО ДРУГОЙ картинке
    print("\n[3] Тестируем поиск по другой картинке (Синий квадрат)...")
    blue_image = create_dummy_image(color='blue')
    files_blue = {'file': ('blueberry.jpg', blue_image, 'image/jpeg')}
    
    response_fail = requests.post(f"{BASE_URL}/search/photo", files=files_blue)
    
    if response_fail.status_code == 404:
        print("✅ УСПЕХ! Система не нашла продукт, так как картинки разные.")
    else:
        print(f"⚠️ Странно, система что-то нашла (или ошибка): {response_fail.status_code} - {response_fail.text}")

if __name__ == "__main__":
    test_flow()