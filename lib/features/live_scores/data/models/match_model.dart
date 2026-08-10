// lib/features/live_scores/data/models/match_model.dart
import '../../domain/entities/match.dart';

class MatchModel {
  final int id;
  final String homeTeamName;
  final String awayTeamName;
  final int homeScore;
  final int awayScore;
  final String status;

  MatchModel({
    required this.id,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeScore,
    required this.awayScore,
    required this.status,
  });

  // Convertit le JSON reçu de l'API en modèle de données Dart
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as int,
      homeTeamName: json['homeTeam']['name'] ?? 'Inconnu',
      awayTeamName: json['awayTeam']['name'] ?? 'Inconnu',
      homeScore: json['score']['fullTime']['home'] ?? 0,
      awayScore: json['score']['fullTime']['away'] ?? 0,
      status: json['status'] ?? 'TIMED',
    );
  }

  // Transforme ce modèle technique en Entité pure pour le Domain
  FootballMatch toEntity() {
    return FootballMatch(
      id: id.toString(),
      homeTeam: homeTeamName,
      awayTeam: awayTeamName,
      homeScore: homeScore,
      awayScore: awayScore,
      isLive:
          status == 'IN_PLAY' ||
          status == 'PAUSED', // Match en cours ou mi-temps
    );
  }
}
