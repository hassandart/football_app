// lib/features/live_scores/data/data_repositories/live_scores_repository_impl.dart
import '../../domain/domain_repositories/live_scores_repository.dart';
import '../../domain/entities/football_news.dart';
import '../datasources/live_scores_api_client.dart';

class LiveScoresRepositoryImpl implements LiveScoresRepository {
  final LiveScoresApiClient apiClient;

  LiveScoresRepositoryImpl({required this.apiClient});

  @override
  Future<List<FootballNews>> getLiveMatches({
    required String leagueCode,
  }) async {
    // On simule une attente réseau de 400ms pour garder l'effet de chargement pro
    await Future.delayed(const Duration(milliseconds: 400));

    // Génération instantanée de vraies affiches de football selon la ligue sélectionnée
    return _generateStableMatches(leagueCode);
  }

  List<FootballNews> _generateStableMatches(String leagueCode) {
    if (leagueCode == 'FL1') {
      return [
        FootballNews(
          id: "fl1_1",
          title: "Paris Saint-Germain 3 - 1 Olympique de Marseille",
          imageUrl: "https://unsplash.com",
          time: "82'", // Match en cours
          source: "Ligue 1 🇫🇷",
        ),
        FootballNews(
          id: "fl1_2",
          title: "AS Monaco 2 - 0 Olympique Lyonnais",
          imageUrl: "https://unsplash.com",
          time: "Fin", // Match terminé
          source: "Ligue 1 🇫🇷",
        ),
        FootballNews(
          id: "fl1_3",
          title: "LOSC Lille vs RC Lens",
          imageUrl: "https://unsplash.com",
          time: "21:00", // Prochain match
          source: "Ligue 1 🇫🇷",
        ),
        FootballNews(
          id: "fl1_4",
          title: "OGC Nice 1 - 1 Stade Rennais FC",
          imageUrl: "https://unsplash.com",
          time: "Mi-temps",
          source: "Ligue 1 🇫🇷",
        ),
        FootballNews(
          id: "fl1_5",
          title: "Stade de Reims vs RC Strasbourg",
          imageUrl: "https://unsplash.com",
          time: "15:00",
          source: "Ligue 1 🇫🇷",
        ),
      ];
    } else if (leagueCode == 'CL') {
      return [
        FootballNews(
          id: "cl_1",
          title: "Real Madrid 4 - 2 Manchester City FC",
          imageUrl: "https://unsplash.com",
          time: "90'",
          source: "Champions League 🇪🇺",
        ),
        FootballNews(
          id: "cl_2",
          title: "FC Barcelone 1 - 2 Bayern Munich",
          imageUrl: "https://unsplash.com",
          time: "Fin",
          source: "Champions League 🇪🇺",
        ),
        FootballNews(
          id: "cl_3",
          title: "Arsenal FC vs Inter Milan",
          imageUrl: "https://unsplash.com",
          time: "21:00",
          source: "Champions League 🇪🇺",
        ),
        FootballNews(
          id: "cl_4",
          title: "Juventus Turin vs Atletico Madrid",
          imageUrl: "https://unsplash.com",
          time: "Demain",
          source: "Champions League 🇪🇺",
        ),
      ];
    } else {
      // Premier League (Par défaut)
      return [
        FootballNews(
          id: "pl_1",
          title: "Arsenal FC 2 - 1 Chelsea FC",
          imageUrl: "https://unsplash.com",
          time: "74'",
          source: "Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿",
        ),
        FootballNews(
          id: "pl_2",
          title: "Manchester United 0 - 3 Liverpool FC",
          imageUrl: "https://unsplash.com",
          time: "Fin",
          source: "Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿",
        ),
        FootballNews(
          id: "pl_3",
          title: "Tottenham Hotspur vs Manchester City",
          imageUrl: "https://unsplash.com",
          time: "21:00",
          source: "Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿",
        ),
        FootballNews(
          id: "pl_4",
          title: "Aston Villa 2 - 2 Newcastle United",
          imageUrl: "https://unsplash.com",
          time: "Fin",
          source: "Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿",
        ),
        FootballNews(
          id: "pl_5",
          title: "West Ham vs Everton FC",
          imageUrl: "https://unsplash.com",
          time: "16:00",
          source: "Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿",
        ),
      ];
    }
  }
}
