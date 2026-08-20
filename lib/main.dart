// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_app/features/live_scores/data/data_repositories/live_scores_repository_impl.dart';
import 'package:football_app/features/presentation/controllers/live_scores_provider.dart';
import 'package:provider/provider.dart';
import 'package:football_app/app.dart';
import 'package:football_app/core/network/dio_client.dart';
import 'package:football_app/features/live_scores/data/datasources/live_scores_api_client.dart';
import 'package:football_app/features/live_scores/domain/domain_repositories/live_scores_repository.dart';

void main() async {
  runApp(const MyAppDependencies());
  // 🟢 Assure l'initialisation complète des liaisons Flutter avant de configurer l'orientation
  WidgetsFlutterBinding.ensureInitialized();

  // 🟢 Bloque l'application uniquement en mode Portrait (Normal et Renversé)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyAppDependencies extends StatelessWidget {
  const MyAppDependencies({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DioClient>(create: (_) => DioClient()),

        // LIGNE CORRIGÉE : Utilisation exclusive du paramètre nommé 'dio'
        ProxyProvider<DioClient, LiveScoresApiClient>(
          update: (_, dioClient, _) => LiveScoresApiClient(dio: dioClient.dio),
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
