// lib/features/live_scores/domain/entities/match.dart
class FootballMatch {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final bool isLive;

  FootballMatch({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.isLive,
  });
}
