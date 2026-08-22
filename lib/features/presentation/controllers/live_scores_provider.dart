// lib/features/presentation/controllers/live_scores_provider.dart
import 'package:flutter/material.dart';
import 'package:football_app/features/live_scores/domain/entities/football_news.dart';

class LiveScoresProvider extends ChangeNotifier {
  LiveScoresProvider({dynamic repository});

  List<FootballNews> _matches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FootballNews> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set repository(dynamic value) {}

  Future<void> fetchLiveMatches({String leagueCode = 'PL'}) async {
    // 🔍 ESPION 1 : Vérifie si la fonction est bien appelée par l'écran
    debugPrint(
      "⚽ [PROVIDER] fetchLiveMatches appelé avec le code de ligue : $leagueCode",
    );

    _isLoading = true;
    _errorMessage = null;
    _matches = [];
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 200));

    try {
      String name = (leagueCode == 'FL1')
          ? 'Bundesliga 🇩🇪'
          : (leagueCode == 'CL'
                ? 'Champions League 🇪🇺'
                : 'Premier League 🏴%E2%80%99%F0%9F%8F%B4%F0%9F%8F%A7%E2%80%8D%E2%99%82%EF%B8%8F');

      if (leagueCode == 'FL1') {
        _matches = [
          FootballNews(
            id: "b1",
            title: "Bayern Munich 3 - 1 Borussia Dortmund",
            imageUrl: "https://unsplash.com",
            time: "82'",
            source: name,
          ),
          FootballNews(
            id: "b2",
            title: "RB Leipzig 2 - 0 Bayer Leverkusen",
            imageUrl: "https://unsplash.com",
            time: "Fin",
            source: name,
          ),
          FootballNews(
            id: "b3",
            title: "Eintracht Frankfurt 1 - 1 VfB Stuttgart",
            imageUrl: "https://unsplash.com",
            time: "Mi-temps",
            source: name,
          ),
          FootballNews(
            id: "b4",
            title: "Borussia M'gladbach vs VfL Wolfsburg",
            imageUrl: "https://unsplash.com",
            time: "21:00",
            source: name,
          ),
          FootballNews(
            id: "b5",
            title: "Fribourg 0 - 2 TSG Hoffenheim",
            imageUrl: "https://unsplash.com",
            time: "15:30",
            source: name,
          ),
        ];
      } else if (leagueCode == 'CL') {
        _matches = [
          FootballNews(
            id: "c1",
            title: "Real Madrid 4 - 2 Manchester City FC",
            imageUrl: "https://unsplash.com",
            time: "90'",
            source: name,
          ),
          FootballNews(
            id: "c2",
            title: "FC Barcelone 1 - 2 Bayern Munich",
            imageUrl: "https://unsplash.com",
            time: "Fin",
            source: name,
          ),
          FootballNews(
            id: "c3",
            title: "Arsenal FC vs Inter Milan",
            imageUrl: "https://unsplash.com",
            time: "21:00",
            source: name,
          ),
          FootballNews(
            id: "c4",
            title: "Juventus Turin vs Atletico Madrid",
            imageUrl: "https://unsplash.com",
            time: "Demain",
            source: name,
          ),
          FootballNews(
            id: "c5",
            title: "AC Milan 1 - 0 Paris Saint-Germain",
            imageUrl: "https://unsplash.com",
            time: "Fin",
            source: name,
          ),
        ];
      } else {
        _matches = [
          FootballNews(
            id: "p1",
            title: "Arsenal FC 2 - 1 Chelsea FC",
            imageUrl: "https://unsplash.com",
            time: "74'",
            source: name,
          ),
          FootballNews(
            id: "p2",
            title: "Manchester United 0 - 3 Liverpool FC",
            imageUrl: "https://unsplash.com",
            time: "Fin",
            source: name,
          ),
          FootballNews(
            id: "p3",
            title: "Tottenham Hotspur vs Manchester City",
            imageUrl: "https://unsplash.com",
            time: "21:00",
            source: name,
          ),
          FootballNews(
            id: "p4",
            title: "Aston Villa 2 - 2 Newcastle United",
            imageUrl: "https://unsplash.com",
            time: "Fin",
            source: name,
          ),
          FootballNews(
            id: "p5",
            title: "West Ham vs Everton FC",
            imageUrl: "https://unsplash.com",
            time: "16:00",
            source: name,
          ),
        ];
      }

      // 🔍 ESPION 2 : Vérifie combien d'éléments ont été injectés
      debugPrint(
        "📊 [PROVIDER] Matchs chargés avec succès. Nombre d'éléments : ${_matches.length}",
      );
      if (_matches.isNotEmpty) {
        debugPrint(
          "📝 [PROVIDER] Premier match généré : ${_matches.first.title}",
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      // 🔍 ESPION 3 : Attrape un éventuel crash interne invisible
      debugPrint("🚨 [PROVIDER] CRASH INTERNE DANS FETCH : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      // 🔍 ESPION 4 : Alerte quand les widgets graphiques reçoivent l'ordre de redessiner
      debugPrint(
        "📢 [PROVIDER] notifyListeners() envoyé à l'interface graphique.",
      );
    }
  }
}
