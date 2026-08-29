import '../../domain/entities/movie.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  // 1. Convertit le JSON brut reçu de l'API TMDB via Dio en un objet MovieModel
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      // ATTENTION À CETTE LIGNE : Il faut bien écrire 'poster_path' ⬇️
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // 2. Méthode essentielle de la Clean Architecture : convertit ce modèle de données (Data)
  // en une entité pure (Domain) exploitable par les couches supérieures (Provider / UI)
  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterUrl:
          posterPath, // 👈 On transmet le chemin de l'API TMDB (ex: /path.jpg)
      rating: voteAverage,
    );
  }
}
