// lib/features/live_scores/data/datasources/live_scores_api_client.dart
import 'package:dio/dio.dart';

class LiveScoresApiClient {
  final Dio _dio;

  LiveScoresApiClient(this._dio);

  Future<Map<String, dynamic>> getTodayMatchesRaw() async {
    try {
      // Endpoint officiel pour récupérer les matchs du jour
      final response = await _dio.get('matches');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Erreur réseau API Football : ${e.message}');
    }
  }
}
