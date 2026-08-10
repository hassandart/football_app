// lib/features/live_scores/data/data_repositories/live_scores_repository_impl.dart
import 'package:football_app/features/live_scores/domain/domain_repositories/live_scores_repository.dart';
import 'package:football_app/features/live_scores/domain/entities/match.dart';
import 'package:football_app/features/live_scores/data/datasources/live_scores_api_client.dart';

class LiveScoresRepositoryImpl implements LiveScoresRepository {
  final LiveScoresApiClient apiClient;

  LiveScoresRepositoryImpl({required this.apiClient});

  @override
  Future<List<FootballMatch>> getLiveMatches() async {
    // Simule un temps de chargement réseau fluide de 800ms
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      FootballMatch(
        id: '101',
        homeTeam: 'Real Madrid',
        awayTeam: 'FC Barcelone',
        homeScore: 2,
        awayScore: 2,
        isLive: true,
      ),
      FootballMatch(
        id: '102',
        homeTeam: 'Paris SG',
        awayTeam: 'Marseille',
        homeScore: 1,
        awayScore: 0,
        isLive: true,
      ),
      FootballMatch(
        id: '103',
        homeTeam: 'Manchester City',
        awayTeam: 'Liverpool',
        homeScore: 0,
        awayScore: 3,
        isLive: false,
      ),
    ];
  }
}
