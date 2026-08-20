// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'X-Auth-Token': ApiConstants.apiKey, // Seul ce header est requis !
      },
    ),
  );
}
