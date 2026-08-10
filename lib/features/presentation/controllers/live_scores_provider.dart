// lib/features/live_scores/presentation/controllers/live_scores_provider.dart
import 'package:flutter/material.dart';
import 'package:football_app/features/live_scores/domain/domain_repositories/live_scores_repository.dart';
import 'package:football_app/features/live_scores/domain/entities/match.dart';

class LiveScoresProvider extends ChangeNotifier {
  LiveScoresRepository _repository;

  LiveScoresProvider({required LiveScoresRepository repository})
    : _repository = repository;

  set repository(LiveScoresRepository value) {
    _repository = value;
  }

  List<FootballMatch> _matches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FootballMatch> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLiveMatches() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Affiche l'indicateur de chargement à l'écran

    try {
      _matches = await _repository.getLiveMatches();
    } catch (e) {
      _errorMessage = "Impossible de récupérer les scores en direct.";
    } finally {
      _isLoading = false;
      notifyListeners(); // Rafraîchit l'écran avec les données ou l'erreur
    }
  }
}
