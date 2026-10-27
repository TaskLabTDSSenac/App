import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBaseUrl =>
      const String.fromEnvironment('API_BASE_URL', defaultValue: '').isNotEmpty
      ? const String.fromEnvironment('API_BASE_URL')
      : !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8000'
      : 'http://127.0.0.1:8000';
  // OpenAPI confirmado: GET /users/me, sem PUT/PATCH de dados pessoais.
  static const profileEditingAvailable = false;
}
