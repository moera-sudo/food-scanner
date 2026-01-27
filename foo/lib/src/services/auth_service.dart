import 'package:dio/dio.dart';
import 'package:foo/src/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;
  
  // Берем интерсептор прямо из ApiClient, он там уже один и правильный
  final _authInterceptor = ApiClient().authInterceptor; 

  // Больше не нужно передавать интерсептор в конструктор
  AuthService(); 

  static const _accessTokenKey = 'access_token'; // Ключ тот же

  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove('refresh_token');
    
    // Также чистим в памяти интерсептора
    ApiClient().authInterceptor.setTokens(accessToken: '', refreshToken: ''); 
  }

  Future<bool> login({required String loginInput, required String password}) async {
    try {
      final isEmail = loginInput.contains('@');
      
      final response = await _dio.post(
        '/user/auth',
        data: {
          'email': isEmail ? loginInput : null,
          'username': isEmail ? null : loginInput,
          'data_type': isEmail ? 'email' : 'username',
          'password': password,
        },
      );

      final access = response.data['access_token'];
      final refresh = response.data['refresh_token'];
      final theme = response.data['theme_mode']; // Если нужно

      if (access != null && refresh != null) {
        // Сохраняем токены через глобальный интерсептор
        await _authInterceptor.setTokens(
          accessToken: access,
          refreshToken: refresh,
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('Login error: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> register({required String name, required String email, required String password}) async {
      // (оставляем без изменений)
      try {
      final response = await _dio.post(
        '/user/reg',
        data: {
          'email': email,
          'username': name,
          'password': password,
        },
      );
      return response.statusCode == 201;
    } catch (e) {
        return false;
    }
  }
}