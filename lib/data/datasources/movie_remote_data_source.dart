import 'package:dio/dio.dart';
import '../../core/dio_client.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final DioClient _dioClient;

  MovieRemoteDataSource(this._dioClient);

  /// Récupère la liste des films populaires depuis l'API TMDB
  Future<List<MovieModel>> fetchPopularMovies() async {
    try {
      // Grâce à l'intercepteur de notre DioClient, l'URL finale sera automatiquement :
      // https://themoviedb.org
      final response = await _dioClient.dio.get('/movie/popular');

      // TMDB renvoie un objet JSON contenant une liste dans la clé 'results'
      final List<dynamic> results = response.data['results'];

      // On transforme chaque JSON de la liste en un objet MovieModel
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // On capture l'erreur réseau formatée par notre intercepteur et on la propage
      throw Exception(
        e.error ??
            'Une erreur réseau est survenue lors de la récupération des films.',
      );
    } catch (e) {
      // Capture les autres erreurs potentielles (ex: problème de parsing JSON)
      throw Exception('Erreur inattendue : $e');
    }
  }
}
