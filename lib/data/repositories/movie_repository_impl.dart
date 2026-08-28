import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Movie>> getPopularMovies() async {
    try {
      // 1. On va chercher les modèles bruts de l'API
      final models = await remoteDataSource.fetchPopularMovies();

      // 2. On transforme chaque MovieModel en entité pure Movie pour la couche Domain
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // On laisse passer l'erreur brute ou on la reformate si nécessaire
      rethrow;
    }
  }
}
