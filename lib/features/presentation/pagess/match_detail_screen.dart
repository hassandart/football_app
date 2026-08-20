// lib/features/presentation/pagess/match_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:football_app/core/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MatchDetailScreen extends StatefulWidget {
  final dynamic match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Génération dynamique des sous-écrans pour garantir la mise à jour des données
    final List<Widget> tabs = [
      _buildOverviewTab(),
      _buildStatsTab(),
      _buildLineupsTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.match.source.toUpperCase(), // 🟢 CORRIGÉ : sourceStr -> source
          style: const TextStyle(
            color: AppColors.accentGold,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- EN-TÊTE DU MATCH (SCORE & ÉQUIPES) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                if (widget.match.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.match.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (c, u, e) => const SizedBox.shrink(),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  widget.match.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.match.time, // 🟢 CORRIGÉ : gmtTime -> time
                    style: const TextStyle(
                      color: AppColors.backgroundDark,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- CONTENU DYNAMIQUE DE L'ONGLET ACTIF ---
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: tabs[_currentIndex],
            ),
          ),
        ],
      ),

      // --- BARRE DE NAVIGATION INFÉRIEURE AU DESSOUS ---
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.cardDark,
          selectedItemColor: AppColors.accentGold,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: 'Infos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: 'Compos',
            ),
          ],
        ),
      ),
    );
  }

  // --- CONTENU DE L'ONGLET : INFOS GÉNÉRALES ---
  Widget _buildOverviewTab() {
    return ListView(
      key: const ValueKey('OverviewTab'),
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoTile(
          Icons.source,
          'Source',
          widget.match.source,
        ), // 🟢 CORRIGÉ : sourceStr -> source
        _buildInfoTile(
          Icons.access_time,
          'Heure GMT',
          widget.match.time,
        ), // 🟢 CORRIGÉ : gmtTime -> time
        _buildInfoTile(Icons.tag, 'ID Match', widget.match.id),
      ],
    );
  }

  // --- CONTENU DE L'ONGLET : STATISTIQUES (EXEMPLE GRAPHIQUE) ---
  Widget _buildStatsTab() {
    return ListView(
      key: const ValueKey('StatsTab'),
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: Text(
            "STATISTIQUES DU MATCH",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildStatRow('Possession', 45, 55),
        _buildStatRow('Tirs Cadrés', 4, 7),
        _buildStatRow('Fautes', 12, 8),
        _buildStatRow('Corners', 5, 3),
      ],
    );
  }

  // --- CONTENU DE L'ONGLET : COMPOSITIONS ---
  Widget _buildLineupsTab() {
    return const Center(
      key: ValueKey('LineupsTab'),
      child: Text(
        'Compositions tactiques bientôt disponibles',
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  // --- WIDGETS COMPOSANTS RÉUTILISABLES (DESIGN COHÉRENT) ---
  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentGold, size: 20),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int homeValue, int awayValue) {
    final double total = (homeValue + awayValue).toDouble();
    final double homeRatio = total > 0 ? homeValue / total : 0.5;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$homeValue',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                '$awayValue',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: Row(
                children: [
                  Expanded(
                    flex: (homeRatio * 100).toInt(),
                    child: Container(color: AppColors.accentGold),
                  ),
                  Expanded(
                    flex: ((1 - homeRatio) * 100).toInt(),
                    child: Container(color: Colors.white24),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
