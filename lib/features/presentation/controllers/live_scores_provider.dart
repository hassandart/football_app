// lib/features/presentation/controllers/live_scores_provider.dart
import 'package:flutter/material.dart';
import 'package:football_app/features/live_scores/domain/domain_repositories/live_scores_repository.dart';
import 'package:football_app/features/live_scores/domain/entities/football_news.dart';

class LiveScoresProvider extends ChangeNotifier {
  LiveScoresRepository _repository;

  LiveScoresProvider({required LiveScoresRepository repository})
    : _repository = repository;

  List<FootballNews> _matches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FootballNews> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set repository(LiveScoresRepository value) {
    if (_repository != value) {
      _repository = value;
      notifyListeners();
    }
  }

  Future<void> fetchLiveMatches({String leagueCode = 'PL'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _matches = await _repository.getLiveMatches(leagueCode: leagueCode);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // 🟢 RECTIFICATION : Le mot-clé 'finally' a été rajouté ici
      _isLoading = false;
      notifyListeners();
    }
  }
}
