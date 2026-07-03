import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/match_provider.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scores en Direct"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MatchProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.matches.length,
            itemBuilder: (context, index) {
              final match = provider.matches[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          match.homeTeam,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${match.homeScore} - ${match.awayScore}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          match.awayTeam,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        label: Text(
                          match.matchTime,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          matchProvider.simulateGoalNotification(
            "1",
            2,
            0,
            "48'",
          ); // Simule un but du PSG
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.sports_soccer, color: Colors.white),
      ),
    );
  }
}
