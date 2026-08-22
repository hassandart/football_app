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

    // Sécurisation de la source : gère si l'API renvoie une String ou une Map
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

    // Normalisation de l'URL de l'image (évite les erreurs d'URL relatives)
    // Dans NewsModel.fromJson
    String rawImageUrl =
        json['imageUrl'] as String? ?? json['urlToImage'] as String? ?? '';
    if (rawImageUrl.isEmpty || !rawImageUrl.startsWith('http')) {
      rawImageUrl =
          'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=500'; // Image de foot par défaut
    }

    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Aucun titre',
      imageUrl: rawImageUrl,
      gmtTime:
          json['gmtTime'] as String? ?? json['publishedAt'] as String? ?? '',
      sourceStr: extractedSource,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'gmtTime': gmtTime,
      'sourceStr': sourceStr,
    };
  }

  FootballNews toEntity() {
    String formattedTime = 'En ligne';

    if (gmtTime.contains('T')) {
      try {
        final List<String> parts = gmtTime.split('T');
        if (parts.length > 1) {
          final String timeString = parts[1];
          formattedTime = timeString.substring(0, 5); // Extrait "HH:mm"
        }
      } catch (_) {
        formattedTime = 'Récent';
      }
    } else if (gmtTime.isNotEmpty) {
      formattedTime = gmtTime;
    }

    return FootballNews(
      id: id,
      title: title,
      imageUrl: imageUrl,
      time: formattedTime,
      source: sourceStr,
    );
  }

  static List<NewsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .whereType<Map<String, dynamic>>()
        .map((json) => NewsModel.fromJson(json))
        .toList();
  }
}
