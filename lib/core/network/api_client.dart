import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api-komiku-faiznation.up.railway.app',
            connectTimeout: const Duration(seconds: 8),
            receiveTimeout: const Duration(seconds: 8),
          ),
        );

  // Getter untuk mengakses dio jika perlu konfigurasi tambahan (interceptor dll)
  Dio get instance => dio;
}