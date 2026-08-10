// lib/app.dart
import 'package:flutter/material.dart';

import 'package:football_app/features/presentation/pagess/live_scores_dashboard_screen.dart';

class FootballApp extends StatelessWidget {
  const FootballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FootScore Live',
      debugShowCheckedModeBanner: false,
      home: LiveScoresDashboardScreen(),
    );
  }
}
