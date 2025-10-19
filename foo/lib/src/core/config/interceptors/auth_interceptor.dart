import 'package:dio/dio.dart';
import 'package:foo/src/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshing = false;

  final List<Function(RequestOptions)> _retryQueue = [];

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  /// Устанавливаем и сохраняем токены
  void setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);

    print('✅ Tokens saved locally');
  }

  /// При старте приложения можно восстановить токены
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);

    if (_accessToken != null) {
      print('🔁 Tokens restored from SharedPreferences');
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final skipAuthPaths = ['/login', '/register', '/refresh', '/ping'];

    if (!skipAuthPaths.any((path) => options.path.contains(path)) && _accessToken != null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && _refreshToken != null) {
      final dio = ApiClient().dio;

      if (_isRefreshing) {
        _retryQueue.add((options) async {
          options.headers['Authorization'] = 'Bearer $_accessToken';
          return dio.fetch(options);
        });
        return;
      }

      _isRefreshing = true;

      try {
        final refreshResponse = await dio.post(
          '/refresh',
          data: {'refresh_token': _refreshToken},
        );

        final newAccessToken = refreshResponse.data['access_token'];

        if (newAccessToken != null) {
          _accessToken = newAccessToken;

          // Сохраняем новый токен
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_accessTokenKey, newAccessToken);

          // Повторяем исходный запрос
          final retryRequest = err.requestOptions;
          retryRequest.headers['Authorization'] = 'Bearer $_accessToken';

          final Response retryResponse = await dio.fetch(retryRequest);

          for (final queued in _retryQueue) {
            await queued(retryRequest);
          }
          _retryQueue.clear();

          handler.resolve(retryResponse);
          return;
        }
      } catch (refreshError) {
        handler.reject(refreshError as DioException);
        return;
      } finally {
        _isRefreshing = false;
      }
    }

    super.onError(err, handler);
  }
}
