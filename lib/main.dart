// lib/main.dart
import 'package:flutter/material.dart';
import 'package:football_app/features/live_scores/data/data_repositories/live_scores_repository_impl.dart';
import 'package:football_app/features/presentation/controllers/live_scores_provider.dart';
import 'package:provider/provider.dart';
import 'package:football_app/app.dart';
import 'package:football_app/core/network/dio_client.dart';
import 'package:football_app/features/live_scores/data/datasources/live_scores_api_client.dart';

import 'package:football_app/features/live_scores/domain/domain_repositories/live_scores_repository.dart';

void main() {
  runApp(const MyAppDependencies());
}

class MyAppDependencies extends StatelessWidget {
  const MyAppDependencies({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DioClient>(create: (_) => DioClient()),

        ProxyProvider<DioClient, LiveScoresApiClient>(
          update: (_, dioClient, _) => LiveScoresApiClient(dioClient.dio),
        ),

        ProxyProvider<LiveScoresApiClient, LiveScoresRepository>(
          update: (_, apiClient, _) =>
              LiveScoresRepositoryImpl(apiClient: apiClient),
        ),

        ChangeNotifierProxyProvider<LiveScoresRepository, LiveScoresProvider>(
          create: (context) => LiveScoresProvider(
            repository: context.read<LiveScoresRepository>(),
          ),
          update: (_, repository, provider) =>
              provider!..repository = repository,
        ),
      ],
      child: const FootballApp(),
    );
  }
}
