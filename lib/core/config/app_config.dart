// lib/core/config/app_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'Cotopaxi Airlines';

  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ??
      'http://cotopaxi-airlines-api.uaeftt-ute.site/api';
}
