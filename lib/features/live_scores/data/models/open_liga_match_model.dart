// lib/features/live_scores/data/models/open_liga_match_model.dart
import '../../domain/entities/football_news.dart';

class OpenLigaMatchModel {
  final int matchId;
  final String team1Name;
  final String team2Name;
  final int scoreTeam1;
  final int scoreTeam2;
  final String matchDateTime;
  final bool isFinished;

  OpenLigaMatchModel({
    required this.matchId,
    required this.team1Name,
    required this.team2Name,
    required this.scoreTeam1,
    required this.scoreTeam2,
    required this.matchDateTime,
    required this.isFinished,
  });

  factory OpenLigaMatchModel.fromJson(Map<String, dynamic> json) {
    int points1 = 0;
    int points2 = 0;
    final results = json['matchResults'] as List<dynamic>? ?? [];
    if (results.isNotEmpty) {
      final lastResult = results.last;
      points1 = lastResult['pointsTeam1'] ?? 0;
      points2 = lastResult['pointsTeam2'] ?? 0;
    }

    return OpenLigaMatchModel(
      matchId: json['matchID'] ?? 0,
      team1Name: json['team1']?['teamName'] ?? 'Équipe 1',
      team2Name: json['team2']?['teamName'] ?? 'Équipe 2',
      scoreTeam1: points1,
      scoreTeam2: points2,
      matchDateTime: json['matchDateTime'] ?? '',
      isFinished: json['matchIsFinished'] ?? false,
    );
  }

  // 🟢 LA CLEF : Transformer le match OpenLiga en FootballNews compatible avec votre UI
  FootballNews toEntity() {
    String scoreOrTime = isFinished
        ? '$scoreTeam1 - $scoreTeam2'
        : (matchDateTime.contains('T')
              ? matchDateTime.split('T')[1].substring(0, 5)
              : 'À venir');

    return FootballNews(
      id: matchId.toString(),
      title: '$team1Name vs $team2Name', // Combiné pour votre `match.title`
      imageUrl: '', // OpenLigaDB ne fournit pas d'images d'actualité
      time: scoreOrTime, // Utilise le score ou l'heure pour `match.time`
      source: 'Bundesliga', // Défini pour `match.source`
    );
  }
}
