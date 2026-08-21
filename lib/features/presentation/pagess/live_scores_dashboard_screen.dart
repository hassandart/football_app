// lib/features/presentation/pagess/live_scores_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:football_app/features/presentation/controllers/live_scores_provider.dart';
import 'package:football_app/features/presentation/pagess/match_detail_screen.dart';

import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';

class LiveScoresDashboardScreen extends StatefulWidget {
  const LiveScoresDashboardScreen({super.key});

  @override
  State<LiveScoresDashboardScreen> createState() =>
      _LiveScoresDashboardScreenState();
}

class _LiveScoresDashboardScreenState extends State<LiveScoresDashboardScreen> {
  String _selectedLeague = 'Ligue 1 🇫🇷';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveScoresProvider>().fetchLiveMatches();
    });
  }

  void _showLeagueSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choisir une compétition',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ListTile(
                title: const Text('Ligue 1 🇫🇷'),
                onTap: () => _updateLeague('Ligue 1 🇫🇷'),
              ),
              ListTile(
                title: const Text('Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
                onTap: () => _updateLeague('Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
              ),
              ListTile(
                title: const Text('Champions League 🇪🇺'),
                onTap: () => _updateLeague('Champions League 🇪🇺'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateLeague(String league) {
    setState(() {
      _selectedLeague = league;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveScoresProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      // backgroundColor: AppColors.backgroundLight,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryGreen),
              child: Text(
                'MENU FOOT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon Profil'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundDark,
        centerTitle: true,
        title: GestureDetector(
          onTap: () => _showLeagueSelector(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedLeague,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aucune nouvelle notification')),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : CustomScrollView(
              slivers: [
                // --- 1ère UI : LISTE HORIZONTALE ---
                // --- 1ère UI : LISTE HORIZONTALE AVEC FOND DÉGRADÉ ---
                SliverToBoxAdapter(
                  child: Container(
                    // 🟢 RECTIFICATION : Ajout d'un dégradé de fond immersif
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.backgroundDark,
                          AppColors
                              .backgroundDark, // Se fond magnifiquement avec le thème sombre
                        ],
                      ),
                    ),
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      itemCount: provider.matches.length >= 3
                          ? 3
                          : provider.matches.length,
                      itemBuilder: (context, index) {
                        final match = provider.matches[index];
                        return Container(
                          width: 155,
                          margin: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MatchDetailScreen(match: match),
                                ),
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.white.withValues(
                                alpha: 0.15,
                              ), // 🟢 Cartes semi-transparentes ultra-modernes
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.sports_soccer,
                                      color: AppColors.accentGold,
                                      size: 20,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      match.source.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.accentGold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          match.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Colors
                                                .white, // Texte en blanc pour être lisible sur le fond sombre
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        match.time,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // --- 2ème UI : CARTE IMAGE À LA UNE ---
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: provider.matches.isNotEmpty
                        ? InkWell(
                            onTap: () {},
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              clipBehavior: Clip.antiAlias,
                              elevation: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // À mettre directement à l'intérieur du Column de votre carte "À LA UNE" :
                                  Container(
                                    height: 140,
                                    width: double.infinity,
                                    color: AppColors.primaryGreen.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons
                                            .stadium_outlined, // 🟢 Icône vectorielle de stade pro (Zéro chargement internet)
                                        color: AppColors.primaryGreen,
                                        size: 50,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.matches[0].source
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.primaryGreen,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          provider.matches[0].title,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          provider.matches[0].time,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                // --- 3ème UI : FIL VERTICAL AVEC IMAGE ---
                if (provider.matches.length > 1)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        // Affiche le reste des matchs à partir du deuxième élément
                        final match = provider.matches[index + 1];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: match.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.black,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.black,
                                  child: const Icon(
                                    Icons.newspaper,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    match.source,
                                    style: const TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    match.time,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }, childCount: provider.matches.length - 1),
                    ),
                  ),
              ],
            ),
    );
  }
}
