// lib/features/live_scores/data/models/news_model.dart
import '../../domain/entities/football_news.dart';

class NewsModel {
  final String id;
  final String title;
  final String imageUrl;
  final String gmtTime;
  final String sourceStr;

  NewsModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.gmtTime,
    required this.sourceStr,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String extractedSource = 'Inconnue';

    // Sécurisation de la source : gère si l'API renvoie un String ou un Map
    if (json['sourceStr'] != null) {
      if (json['sourceStr'] is Map) {
        extractedSource = json['sourceStr']['name']?.toString() ?? 'Inconnue';
      } else {
        extractedSource = json['sourceStr'].toString();
      }
    } else if (json['source'] != null) {
      if (json['source'] is Map) {
        extractedSource = json['source']['name']?.toString() ?? 'Inconnue';
      } else {
        extractedSource = json['source'].toString();
      }
    }

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Aucun titre',
      imageUrl: json['imageUrl'] as String? ?? '',
      gmtTime:
          json['gmtTime'] as String? ?? json['publishedAt'] as String? ?? '',
      sourceStr: extractedSource,
    );
  }

  FootballNews toEntity() {
    String formattedTime = 'En ligne';

    if (gmtTime.contains('T')) {
      try {
        final List<String> parts = gmtTime.split('T');
        if (parts.length > 1) {
          final String timeString = parts[1];
          formattedTime = timeString.substring(
            0,
            5,
          ); // Extrait proprement "HH:mm"
        }
      } catch (_) {
        formattedTime = 'Récent';
      }
    } else if (gmtTime.isNotEmpty) {
      formattedTime =
          gmtTime; // Conserve le format brut si l'API l'a déjà nettoyé
    }

    return FootballNews(
      id: id,
      title: title,
      imageUrl: imageUrl,
      time: formattedTime,
      source: sourceStr,
    );
  }

  //  CODE OPTIMISÉ ET CORRIGÉ
  static List<NewsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .whereType<
          Map<String, dynamic>
        >() // Utilisation de whereType demandée par le linter
        .map((json) => NewsModel.fromJson(json))
        .toList();
  }
}
