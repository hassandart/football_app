// lib/features/live_scores/domain/domain_repositories/live_scores_repository.dart
import 'package:football_app/features/live_scores/domain/entities/match.dart';

abstract class LiveScoresRepository {
  Future<List<FootballMatch>> getLiveMatches();
}
