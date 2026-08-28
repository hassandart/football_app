import '../entities/movie.dart';

abstract class MovieRepository {
  /// Récupère la liste des films populaires transformés en entités pures
  Future<List<Movie>> getPopularMovies();
}
