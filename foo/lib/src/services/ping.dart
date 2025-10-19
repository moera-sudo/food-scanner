import 'package:dio/dio.dart';

class PingService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000', // localhost для Android-эмулятора
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<void> sendPing() async {
    try {
      final response = await _dio.get('/api/ping');
      print('[PingService] ✅ Response: ${response.data}');
    } catch (e) {
      print('[PingService] ❌ Error: $e');
    }
  }
}
