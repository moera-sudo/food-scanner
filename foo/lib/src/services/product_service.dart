import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:foo/src/api/api_client.dart';

class ProductService {
  final _dio = ApiClient().dio;

  /// Получение истории
  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final response = await _dio.get('/product/get'); // роут: /get
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      print("❌ History error: ${e.response?.data}");
      rethrow;
    }
  }

  /// Поиск продукта
  Future<int?> searchProduct(String query) async {
    try {
      final response = await _dio.get('/search', queryParameters: {'q': query});
      return response.data['id'] as int?;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      print("❌ Search error: ${e.response?.data}");
      rethrow;
    }
  }

  /// Получение информации о продукте
  Future<Map<String, dynamic>> getProduct(int id) async {
    try {
      final response = await _dio.get('/product/get/$id');
      final responseData = response.data;

      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(responseData);
      print("✅ ОТВЕТ СЕРВЕРА ДЛЯ ПРОДУКТА ID=$id:");
      print(prettyprint);


      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print("❌ Product error: ${e.response?.data}");
      rethrow;
    }
  }

  /// Получение картинки продукта
  String getImageUrl(int productId) {
    final dio = ApiClient().dio;
    final baseUrl = dio.options.baseUrl;
    return '$baseUrl/product/get/image/$productId';
  }
}
