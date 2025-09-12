class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // App Configuration
  static const String appName = 'Post-it';
  static const String appVersion = '1.0.0';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'Flutter App/1.0',
  };

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double borderRadius = 8.0;
}
