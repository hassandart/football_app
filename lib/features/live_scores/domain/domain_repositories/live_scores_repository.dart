// lib/features/live_scores/domain/domain_repositories/live_scores_repository.dart
import 'package:football_app/features/live_scores/domain/entities/football_news.dart';

abstract class LiveScoresRepository {
  Future<List<FootballNews>> getLiveMatches({required String leagueCode});
}
