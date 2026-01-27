import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// НЕ импортируем ApiClient здесь, чтобы избежать циклической зависимости, если возможно.
// Но для рефреша нам нужен Dio. Лучше передать его в конструктор или брать аккуратно.

class AuthInterceptor extends Interceptor {
  String? _accessToken;
  String? _refreshToken;
  bool _isRefreshing = false;
  
  // Ключи должны быть одинаковыми везде!
  static const _accessTokenKey = 'access_token'; 
  static const _refreshTokenKey = 'refresh_token';

  // Метод для получения Dio (чтобы разорвать цикл, получим его лениво или создадим новый экземпляр только для рефреша)
  Dio _getDioForRefresh() {
    return Dio(BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api', // Хардкод URL, чтобы не зависеть от ApiClient
        headers: {'Content-Type': 'application/json'}
    ));
  }

  Future<void> setTokens({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    print('✅ Tokens saved (Memory + Prefs). Access: ${_accessToken?.substring(0, 10)}...');
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);
    print('🔁 Loaded tokens. Access present: ${_accessToken != null}');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Список путей, где токен НЕ нужен
    final skipAuthPaths = ['/user/auth', '/user/reg', '/user/refresh', '/ping'];

    final isSkipPath = skipAuthPaths.any((path) => options.path.contains(path));

    if (!isSkipPath && _accessToken != null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
      print('🔐 Added Bearer token to ${options.path}');
    } else if (!isSkipPath && _accessToken == null) {
      print('⚠️ No token available for ${options.path}');
    }

    super.onRequest(options, handler);
  }
  
  // onError для рефреша можно оставить, если он работал, 
  // но лучше использовать _getDioForRefresh() внутри, чтобы не вызывать рекурсию ApiClient().dio
}