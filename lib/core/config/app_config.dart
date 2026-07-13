// lib/core/config/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url != null && url.trim().isNotEmpty) return url;
    return 'http://cotopaxi-airlines-api.uaeftt-ute.site/api';
  }

  static const String appName = 'Cotopaxi Airlines';
}
