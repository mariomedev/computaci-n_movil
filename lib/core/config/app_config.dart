import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Configuración de la aplicación cargada desde variables de entorno
class AppConfig {
  AppConfig._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  static void validate() {
    if (kDebugMode) {
      debugPrint('🔧 AppConfig initialized');
      debugPrint('📡 API Base URL: $apiBaseUrl');

      if (dotenv.env['API_BASE_URL'] == null) {
        debugPrint('⚠️  API_BASE_URL not set, using default');
      }
    }
  }
}
