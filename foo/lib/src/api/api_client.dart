import 'package:dio/dio.dart';
// Импортируем наш AuthInterceptor
import 'package:foo/src/core/config/interceptors/auth_interceptor.dart'; 

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  
  // Создаем экземпляр AuthInterceptor один раз и храним его здесь
  final AuthInterceptor authInterceptor = AuthInterceptor();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    final options = BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    // ВАЖНО: При старте пытаемся восстановить токены из памяти
    authInterceptor.loadTokens(); 

    // Добавляем ЕДИНСТВЕННЫЙ интерсептор авторизации
    dio.interceptors.add(authInterceptor);
    
    // Добавляем логгер для удобства
    dio.interceptors.add(LogInterceptor(
      requestBody: true, 
      responseBody: true,
      logPrint: (o) => print('DIO LOG: $o'), // Чтобы видеть в консоли
    ));
  }
}