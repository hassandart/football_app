// lib/features/live_scores/presentation/pages/live_scores_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:football_app/features/presentation/controllers/live_scores_provider.dart';
import 'package:football_app/features/presentation/widgets/match_card.dart';
import 'package:provider/provider.dart';
import 'package:football_app/core/constants/app_constants.dart';

class LiveScoresDashboardScreen extends StatefulWidget {
  const LiveScoresDashboardScreen({super.key});

  @override
  State<LiveScoresDashboardScreen> createState() =>
      _LiveScoresDashboardScreenState();
}

class _LiveScoresDashboardScreenState extends State<LiveScoresDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveScoresProvider>().fetchLiveMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveScoresProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : Column(
              children: [
                // 1/3 SUPÉRIEUR : Menu Image Immersif
                _buildHeaderImage(size, provider),

                // 2/3 INFÉRIEURS : Menu de navigation & Liste des Matchs
                Expanded(child: _buildMatchesContainer(provider)),
              ],
            ),
    );
  }

  // Widget pour le tiers supérieur (Image de stade + Match vedette)
  Widget _buildHeaderImage(Size size, LiveScoresProvider provider) {
    final hasMatches = provider.matches.isNotEmpty;
    final topMatch = hasMatches ? provider.matches.first : null;

    return SizedBox(
      height: size.height * 0.35, // Occupe environ 1/3 de l'écran
      width: double.infinity,
      child: Stack(
        children: [
          // Image de fond (Stade de football)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://unsplash.com'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dégradé sombre pour rendre le texte parfaitement lisible
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
          // Contenu textuel sur l'image
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titre de l'application
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FOOT SCORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Icon(Icons.notifications_none, color: Colors.white),
                    ],
                  ),
                  // Affichage du match à la une au centre du dégradé
                  if (topMatch != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.liveRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'MATCH À LA UNE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${topMatch.homeTeam}  ${topMatch.homeScore}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'VS',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${topMatch.awayScore}  ${topMatch.awayTeam}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour les deux tiers inférieurs (Menu Liste)
  Widget _buildMatchesContainer(LiveScoresProvider provider) {
    if (provider.errorMessage != null) {
      return Center(
        child: Text(
          provider.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (provider.matches.isEmpty) {
      return const Center(child: Text('Aucun match disponible aujourd\'hui.'));
    }

    // On retire le premier match puisqu'il est déjà affiché en grand dans le tiers supérieur
    final otherMatches = provider.matches.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 8.0),
          child: Text(
            'AUTRES MATCHS DU JOUR',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: otherMatches.length,
            itemBuilder: (context, index) {
              return MatchCard(match: otherMatches[index]);
            },
          ),
        ),
      ],
    );
  }
}
