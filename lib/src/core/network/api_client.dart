import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class ApiClient {
  final Dio dio;
  ApiClient({Dio? dioClient})
      : dio = dioClient ??
            Dio(BaseOptions(
              baseUrl: AppConstants.baseUrl,
              connectTimeout: AppConstants.connectTimeout,
              receiveTimeout: AppConstants.receiveTimeout,
              headers: AppConstants.defaultHeaders,
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
        logPrint: (obj) => debugPrint('💚💚 API: $obj'),
      ));
    }
  }
}
