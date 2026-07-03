import 'package:flutter/material.dart';
import '../models/match_model.dart';

class MatchProvider with ChangeNotifier {
  List<LiveMatch> _matches = [];
  bool _isLoading = false;

  List<LiveMatch> get matches => _matches;
  bool get isLoading => _isLoading;

  Future<void> fetchLiveMatches() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulation attente réseau

    _matches = [
      LiveMatch(
        id: "1",
        homeTeam: "Paris SG",
        awayTeam: "Marseille",
        homeScore: 1,
        awayScore: 0,
        matchTime: "45'",
      ),
      LiveMatch(
        id: "2",
        homeTeam: "Real Madrid",
        awayTeam: "FC Barcelone",
        homeScore: 2,
        awayScore: 2,
        matchTime: "60'",
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void simulateGoalNotification(
    String matchId,
    int homeScore,
    int awayScore,
    String newTime,
  ) {
    final index = _matches.indexWhere((m) => m.id == matchId);
    if (index != -1) {
      _matches[index].updateScore(homeScore, awayScore, newTime);
      notifyListeners(); // Rafraîchit l'UI instantanément lors d'un but !
    }
  }
}
