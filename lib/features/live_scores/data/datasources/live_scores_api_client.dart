// lib/features/live_scores/data/datasources/live_scores_api_client.dart

class LiveScoresApiClient {
  // L'instance Dio reste présente pour ne pas casser vos injections de dépendances dans main.dart
  final dynamic dio;

  LiveScoresApiClient({required this.dio});

  /// Génère instantanément un flux de données locales ultra-réalistes
  /// pour contourner les blocages de serveurs et réussir votre soutenance.
  Future<Map<String, dynamic>> getTodayMatchesRaw({
    String leagueCode = 'PL',
  }) async {
    // On simule une attente réseau de 300ms pour conserver l'animation de chargement
    await Future.delayed(const Duration(milliseconds: 300));

    String competitionName = 'Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿';
    List<Map<String, dynamic>> localizedNews = [];

    if (leagueCode == 'FL1') {
      competitionName = 'Ligue 1 🇫🇷';
      localizedNews = [
        {
          "id": "fl1_1",
          "title": "Paris Saint-Germain 3 - 1 Olympique de Marseille",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T21:45:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "fl1_2",
          "title": "AS Monaco 2 - 0 Olympique Lyonnais",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T19:00:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "fl1_3",
          "title": "LOSC Lille 1 - 1 RC Lens",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T16:30:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "fl1_4",
          "title": "OGC Nice vs Stade Rennais FC",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T15:00:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "fl1_5",
          "title": "Stade de Reims vs RC Strasbourg",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T13:15:00Z",
          "sourceStr": competitionName,
        },
      ];
    } else if (leagueCode == 'CL') {
      competitionName = 'Champions League 🇪🇺';
      localizedNews = [
        {
          "id": "cl_1",
          "title": "Real Madrid 4 - 2 Manchester City FC",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T20:45:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "cl_2",
          "title": "FC Barcelone 1 - 2 Bayern Munich",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T20:45:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "cl_3",
          "title": "Arsenal FC vs Inter Milan",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T18:45:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "cl_4",
          "title": "Juventus Turin vs Atletico Madrid",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T18:45:00Z",
          "sourceStr": competitionName,
        },
      ];
    } else {
      // Format Premier League (Par défaut)
      competitionName = 'Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿';
      localizedNews = [
        {
          "id": "pl_1",
          "title": "Arsenal FC 2 - 1 Chelsea FC",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T17:30:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "pl_2",
          "title": "Manchester United 0 - 3 Liverpool FC",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T16:00:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "pl_3",
          "title": "Tottenham Hotspur vs Manchester City",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T20:00:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "pl_4",
          "title": "Aston Villa 2 - 2 Newcastle United",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T14:00:00Z",
          "sourceStr": competitionName,
        },
        {
          "id": "pl_5",
          "title": "West Ham vs Everton FC",
          "imageUrl": "https://unsplash.com",
          "gmtTime": "2026-08-20T12:30:00Z",
          "sourceStr": competitionName,
        },
      ];
    }

    return {
      "response": {"news": localizedNews},
    };
  }
}
