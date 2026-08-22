// lib/features/presentation/pagess/live_scores_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:football_app/features/presentation/controllers/live_scores_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import 'match_detail_screen.dart';

class LiveScoresDashboardScreen extends StatefulWidget {
  const LiveScoresDashboardScreen({super.key});

  @override
  State<LiveScoresDashboardScreen> createState() =>
      _LiveScoresDashboardScreenState();
}

class _LiveScoresDashboardScreenState extends State<LiveScoresDashboardScreen> {
  String _selectedLeague = 'Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveScoresProvider>().fetchLiveMatches(leagueCode: 'PL');
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
                title: const Text('Bundesliga 🇩🇪'),
                onTap: () => _updateLeague('Bundesliga 🇩🇪', 'FL1'),
              ),
              ListTile(
                title: const Text('Premier League 🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
                onTap: () => _updateLeague(
                  'Premier League 🏴%E2%80%99%F0%9F%8F%B4%F0%9F%8F%A7%E2%80%8D%E2%99%82%EF%B8%8F',
                  'PL',
                ),
              ),
              ListTile(
                title: const Text('Champions League 🇪🇺'),
                onTap: () => _updateLeague('Champions League 🇪🇺', 'CL'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateLeague(String leagueName, String code) {
    setState(() {
      _selectedLeague = leagueName;
    });
    Navigator.pop(context);
    context.read<LiveScoresProvider>().fetchLiveMatches(leagueCode: code);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LiveScoresProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
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
        backgroundColor: AppColors.primaryGreen,
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
          : provider.matches.isEmpty
          ? const Center(
              child: Text(
                "Aucun match disponible pour le moment.",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                // --- 1ère UI : LISTE HORIZONTALE ---
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.backgroundDark,
                    height: 145,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
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
                            borderRadius: BorderRadius.circular(12),
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: AppColors.cardDark,
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
                                            color: Colors.white,
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
                // --- 2ème UI : CARTE IMAGE À LA UNE ---
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MatchDetailScreen(
                              match: provider.matches.first,
                            ),
                          ),
                        );
                      },
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
                            Container(
                              height: 140,
                              width: double.infinity,
                              color: AppColors.primaryGreen.withValues(
                                alpha: 0.1,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.stadium_outlined,
                                  color: AppColors.primaryGreen,
                                  size: 50,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.matches.first.source.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    provider.matches.first.title,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    provider.matches.first.time,
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
                    ),
                  ),
                ),
                // --- 3ème UI : FIL VERTICAL ANTI-OVERFLOW ---
                if (provider.matches.length > 1)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
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
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen.withValues(
                                        alpha: .1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events_outlined,
                                      color: AppColors.primaryGreen,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          match.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                match.source,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: AppColors.primaryGreen,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              match.time,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
