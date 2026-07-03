class LiveMatch {
  final String id;
  final String homeTeam;
  final String awayTeam;
  int homeScore;
  int awayScore;
  String matchTime;

  LiveMatch({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.matchTime,
  });

  void updateScore(int newHome, int newAway, String newTime) {
    homeScore = newHome;
    awayScore = newAway;
    matchTime = newTime;
  }
}
