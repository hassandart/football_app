// lib/features/live_scores/data/datasources/live_scores_api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LiveScoresApiClient {
  final Dio dio;
  static const String _footballToken = '6ee3696dc7f641d8a022ea6dba29ff4f';

  LiveScoresApiClient({required this.dio});

  // 🟢 MODIFICATION : Ajout du paramètre leagueCode (par défaut 'PL')
  Future<Map<String, dynamic>> getTodayMatchesRaw({
    String leagueCode = 'PL',
  }) async {
    // URL dynamique utilisant le code de la ligue choisie
    final absoluteUrl = 'https://football-data.org';

    try {
      final response = await dio.get(
        absoluteUrl,
        options: Options(headers: {'X-Auth-Token': _footballToken}),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final List<dynamic> apiMatches =
            response.data['matches'] as List<dynamic>? ?? [];

        final List<Map<String, dynamic>> formattedNews = apiMatches.map((
          match,
        ) {
          final String homeTeam =
              match['homeTeam']?['shortName'] ??
              match['homeTeam']?['name'] ??
              'Domicile';
          final String awayTeam =
              match['awayTeam']?['shortName'] ??
              match['awayTeam']?['name'] ??
              'Extérieur';
          final String competition =
              match['competition']?['name'] ?? 'Football';

          final int? homeScore = match['score']?['fullTime']?['home'];
          final int? awayScore = match['score']?['fullTime']?['away'];
          final String scoreString = (homeScore != null && awayScore != null)
              ? '$homeScore - $awayScore'
              : 'vs';

          return {
            "id": match['id']?.toString() ?? '',
            "title": "$homeTeam $scoreString $awayTeam",
            "imageUrl":
                match['homeTeam']?['crest'] ??
                match['competition']?['emblem'] ??
                '',
            "gmtTime": match['utcDate'] ?? '',
            "sourceStr": competition,
          };
        }).toList();

        if (formattedNews.isEmpty) {
          formattedNews.add({
            "id": "0",
            "title":
                "Aucun match programmé pour cette compétition aujourd'hui.",
            "imageUrl": "",
            "gmtTime": DateTime.now().toIso8601String(),
            "sourceStr": "FootScore Live",
          });
        }

        return {
          "response": {"news": formattedNews},
        };
      } else {
        throw Exception('Réponse serveur invalide');
      }
    } on DioException catch (e) {
      debugPrint("🚨 ERREUR DIO API : ${e.message}");
      throw Exception('Erreur réseau football : ${e.message}');
    } catch (e) {
      throw Exception('Une erreur est survenue : $e');
    }
  }
}
