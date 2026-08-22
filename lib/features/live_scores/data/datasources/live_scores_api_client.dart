// lib/features/live_scores/data/datasources/live_scores_api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LiveScoresApiClient {
  final Dio dio;

  LiveScoresApiClient({required this.dio});

  Future<Map<String, dynamic>> getTodayMatchesRaw({
    String leagueCode = 'PL',
  }) async {
    // Mappage des raccourcis OpenLigaDB
    const Map<String, String> shortcuts = {
      'FL1': 'bl1',
      'CL': 'cl',
      'PL': 'pl1',
    };

    const Map<String, String> names = {
      'FL1': 'Bundesliga 🇩🇪',
      'CL': 'Champions League 🇪🇺',
      'PL': 'Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    };

    final String shortcut = shortcuts[leagueCode] ?? 'bl1';
    final String competitionName = names[leagueCode] ?? 'Bundesliga 🇩🇪';

    // Endpoint OpenLigaDB pour récupérer la journée/les matchs courants de la ligue
    final String absoluteUrl =
        'https://api.openligadb.de/getcurrentgroup/$shortcut';

    try {
      final response = await dio.get(absoluteUrl);

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> matchesList = response.data as List<dynamic>;

        if (matchesList.isEmpty) {
          return {
            "response": {"news": []},
          };
        }

        final List<Map<String, dynamic>> formattedNews = matchesList.map((
          match,
        ) {
          final String team1 = match['team1']?['teamName'] ?? 'Domicile';
          final String team2 = match['team2']?['teamName'] ?? 'Extérieur';
          final String logoHome = match['team1']?['teamIconUrl'] ?? '';

          final List<dynamic> matchResults =
              match['matchResults'] as List<dynamic>? ?? [];
          String scoreString = 'vs';

          if (matchResults.isNotEmpty) {
            final lastResult = matchResults.last;
            final int? pointsTeam1 = lastResult['pointsTeam1'];
            final int? pointsTeam2 = lastResult['pointsTeam2'];
            if (pointsTeam1 != null && pointsTeam2 != null) {
              scoreString = '$pointsTeam1 - $pointsTeam2';
            }
          }

          return {
            "id": match['matchID']?.toString() ?? '',
            "title": "$team1 $scoreString $team2",
            "imageUrl": logoHome.isNotEmpty
                ? logoHome
                : 'https://via.placeholder.com/150',
            "gmtTime":
                match['matchDateTime'] ?? DateTime.now().toIso8601String(),
            "sourceStr": competitionName,
          };
        }).toList();

        return {
          "response": {"news": formattedNews},
        };
      }

      return {
        "response": {"news": []},
      };
    } catch (e) {
      debugPrint("🚨 ERREUR REQUETE OPENLIGADB : $e");
      return {
        "response": {"news": []},
      };
    }
  }
}
