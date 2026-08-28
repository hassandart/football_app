import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importations de vos couches d'architecture
import 'core/dio_client.dart';
import 'data/datasources/movie_remote_data_source.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'presentation/providers/movie_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  // 1. Initialisation manuelle et ordonnée de nos dépendances (Clean Architecture)
  final dioClient = DioClient();
  final remoteDataSource = MovieRemoteDataSource(dioClient);
  final movieRepository = MovieRepositoryImpl(remoteDataSource);

  runApp(
    // 2. Injection du Provider au sommet de l'application pour qu'il soit accessible partout
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider(movieRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinéma App',

      // 3. Configuration d'un thème sombre élégant, idéal pour une application de films (style Netflix/TMDB)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Noir profond
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914), // Rouge Cinéma / Netflix
          secondary: Color(0xFFFFB703), // Jaune Or pour les étoiles de notation
          surface: Color(
            0xFF1E1E1E,
          ), // Gris foncé pour les cartes et conteneurs
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // 4. L'écran de démarrage de l'application
      home: const HomeScreen(),
    );
  }
}
