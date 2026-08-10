// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'X-Auth-Token': ApiConstants.apiKey,
            'Accept': 'application/json',
          },
        ),
      ) {
    // CETTE LIGNE AJOUTÉE affiche les requêtes et les erreurs exactes dans votre console Flutter
    dio.interceptors.add(LogInterceptor(responseBody: true, error: true));
  }
}
