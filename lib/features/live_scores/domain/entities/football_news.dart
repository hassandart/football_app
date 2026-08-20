// lib/features/live_scores/domain/entities/football_news.dart
class FootballNews {
  final String id;
  final String title;
  final String imageUrl;
  final String time;
  final String source;

  FootballNews({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.source,
  });
}
