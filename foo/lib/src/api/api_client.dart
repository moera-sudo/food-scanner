import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // --- Статическая часть для реализации синглтона ---
  static final ApiClient _instance = ApiClient._internal();
  
  // --- Публичные поля ---
  late final Dio dio;

  // --- Фабричный конструктор, который всегда возвращает один и тот же экземпляр ---
  factory ApiClient() {
    return _instance;
  }

  // --- Приватный конструктор, который выполняется только один раз ---
  ApiClient._internal() {
    // 1. Базовые настройки для всех запросов
    final options = BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api', // IP-адрес для Android эмулятора
      connectTimeout: const Duration(seconds: 15), // Увеличил таймаут для надежности
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Рекомендуется добавлять для явного указания формата ответа
      },
    );

    dio = Dio(options);

    // 2. Добавляем Interceptor (перехватчик) для всех запросов
    dio.interceptors.add(
      InterceptorsWrapper(
        // --- Выполняется ПЕРЕД каждым запросом ---
        onRequest: (options, handler) async {
          // Получаем экземпляр SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          
          // Читаем токен по ключу. Убедитесь, что этот ключ ('auth_token')
          // совпадает с тем, который вы используете при сохранении токена в AuthService.
          final token = prefs.getString('auth_token');

          // Логгирование для отладки
          if (token != null && token.isNotEmpty) {
            print('🚀 Interceptor: Токен из SharedPreferences найден. Добавляю заголовок...');
            // Если токен существует, добавляем его в заголовок Authorization
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            print('👻 Interceptor: Токен в SharedPreferences не найден. Запрос без авторизации.');
          }

          // Продолжаем выполнение запроса с обновленными заголовками
          return handler.next(options);
        },

        // --- Выполняется ПОСЛЕ получения ответа (успешного) ---
        onResponse: (response, handler) {
          // Здесь можно логировать успешные ответы
          print('✅ [${response.statusCode}] ${response.requestOptions.method} ${response.requestOptions.path}');
          return handler.next(response);
        },

        // --- Выполняется, если произошла ОШИБКА ---
        onError: (DioException e, handler) {
          // Здесь можно логировать ошибки
          print('❌ [${e.response?.statusCode}] ${e.requestOptions.path}: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}