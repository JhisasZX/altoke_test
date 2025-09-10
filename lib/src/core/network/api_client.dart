import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio dio;
  ApiClient({Dio? dioClient})
      : dio = dioClient ??
            Dio(BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        logPrint: (obj) => debugPrint('�� API: $obj'),
      ));
    }
  }
}
