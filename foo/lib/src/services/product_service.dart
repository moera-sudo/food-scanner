import 'package:dio/dio.dart';
import 'package:foo/src/api/api_client.dart';
import 'package:image_picker/image_picker.dart'; // Для XFile

class ProductService {
  final _dio = ApiClient().dio;

  /// Получение истории
  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final response = await _dio.get('/history/get'); // Исправлен роут на /history/get
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print("❌ History error: $e");
      return []; // Возвращаем пустой список, чтобы не крашить UI
    }
  }

  /// Текстовый поиск
  Future<int?> searchProduct(String query) async {
    try {
      final response = await _dio.get('/search/', queryParameters: {'q': query});
      return response.data['id'] as int?;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Поиск по фото (Исправление №4)
  Future<int?> searchByPhoto(XFile imageFile) async {
    try {
      // Формируем FormData для отправки файла
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      final response = await _dio.post('/search/photo', data: formData);
      return response.data['id'] as int?;
    } on DioException catch (e) {
      print("❌ Photo search error: ${e.response?.data}");
      if (e.response?.statusCode == 404) return null; // Не найдено
      rethrow;
    }
  }

  /// Получение продукта
  Future<Map<String, dynamic>> getProduct(int id) async {
    try {
      final response = await _dio.get('/product/get/$id');
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print("❌ Get Product Error: $e");
      rethrow;
    }
  }

  /// Отправка комментария (Исправление №2)
  Future<bool> sendComment(int productId, String text) async {
    try {
      await _dio.post('/comments/new', data: {
        'product_id': productId,
        'text': text,
      });
      return true;
    } catch (e) {
      print("❌ Send Comment Error: $e");
      return false;
    }
  }

  /// Формирование URL картинки
  String getImageUrl(dynamic input) {
    // Если input уже полный URL (например, с другого сайта)
    if (input is String && input.startsWith('http')) return input;
    
    // Если это просто ID продукта, используем эндпоинт
    final dio = ApiClient().dio;
    final baseUrl = dio.options.baseUrl.replaceAll('/api', ''); // Убираем /api
    
    // Если input ID (int) - запрашиваем через эндпоинт
    if (input is int) {
        return '${dio.options.baseUrl}/product/get/image/$input';
    }
    
    // Если input строка (путь файла uploads/...), формируем статику
    if (input is String) {
        // Убираем лишние слэши, если есть
        final cleanPath = input.replaceAll(RegExp(r'^/'), '');
        return '$baseUrl/$cleanPath'; // http://10.0.2.2:8000/uploads/file.jpg
    }
    
    return '';
  }
}