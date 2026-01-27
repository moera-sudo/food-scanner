import 'package:foo/src/api/api_client.dart';
import 'package:foo/src/models/analytics.dart';

class AnalyticsService {
  final _dio = ApiClient().dio;

  Future<Analytics?> getAnalytics() async {
    try {
      final response = await _dio.get('/analytics/');
      return Analytics.fromJson(response.data);
    } catch (e) {
      print("❌ Analytics Error: $e");
      return null;
    }
  }
}