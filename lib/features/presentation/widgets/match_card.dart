// lib/features/live_scores/presentation/widgets/match_card.dart
import 'package:flutter/material.dart';
import 'package:football_app/core/constants/app_constants.dart';
import 'package:football_app/features/live_scores/domain/entities/match.dart';

class MatchCard extends StatelessWidget {
  final FootballMatch match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Row(
          children: [
            // Équipe Domicile
            Expanded(
              flex: 3,
              child: Text(
                match.homeTeam,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),

            // Section Centrale (Score + Badge)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${match.homeScore} - ${match.awayScore}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: match.isLive ? AppColors.liveRed : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (match.isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.liveRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight
                                  .w900, // <-- Corrigé ici (w900 au lieu de black)
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text(
                      'Terminé',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                ],
              ),
            ),

            // Équipe Extérieur
            Expanded(
              flex: 3,
              child: Text(
                match.awayTeam,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
