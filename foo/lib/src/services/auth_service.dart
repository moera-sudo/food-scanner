import 'package:dio/dio.dart';
import 'package:foo/src/api/api_client.dart';
import 'package:foo/src/core/config/interceptors/auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;
  final AuthInterceptor _authInterceptor;

  AuthService(this._authInterceptor);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    print(token);
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  /// Логин

  Future<bool> login({
    required String loginInput, // одно поле (email или username)
    required String password,
  }) async {
    try {
      // Проверяем, содержит ли '@'
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

      if (access != null && refresh != null) {
        _authInterceptor.setTokens(
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

  /// Регистрация
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
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
    } on DioException catch (e) {
      print('Register error: ${e.response?.data}');
      return false;
    }
  }
}
