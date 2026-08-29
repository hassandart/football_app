import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';

// Définition des différents états possibles de l'écran
enum MovieState { initial, loading, loaded, error }

class MovieProvider extends ChangeNotifier {
  final MovieRepository _movieRepository;

  MovieProvider(this._movieRepository);

  // URL de base TMDB pour charger les images
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w185';

  // Variable privée contenant la liste des films et son getter public
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  // Variable privée contenant l'état actuel et son getter public
  MovieState _state = MovieState.initial;
  MovieState get state => _state;

  // Variable privée pour stocker le message d'erreur et son getter public
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Construit l'URL complète pour l'image d'un film
  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$_imageBaseUrl$path';
  }

  /// Fonction principale pour charger les films populaires
  Future<void> loadPopularMovies() async {
    // 1. On passe en mode chargement et on prévient l'UI de s'actualiser (Spinner)
    _state = MovieState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      // 2. On appelle le repository (qui récupère et convertit les données de l'API)
      _movies = await _movieRepository.getPopularMovies();

      // 3. Le chargement a réussi
      _state = MovieState.loaded;
    } catch (e) {
      // 4. Une erreur est survenue (problème réseau, clé API invalide, etc.)
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _state = MovieState.error;
    }

    // 5. On notifie une dernière fois l'UI pour afficher le résultat final
    notifyListeners();
  }
}
