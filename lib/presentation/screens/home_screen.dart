import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    'Tous',
    'Action',
    'Romance',
    'Comédie',
    'Sci-Fi',
    'Drame',
  ];
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<MovieProvider>().loadPopularMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          // 1. ÉTAT CHARGEMENT
          if (provider.state == MovieState.loading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
              ),
            );
          }

          // 2. ÉTAT ERREUR
          if (provider.state == MovieState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadPopularMovies(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                    ),
                    child: const Text(
                      'Réessayer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          // 3. ÉTAT CHARGÉ (SUCCÈS)
          if (provider.state == MovieState.loaded &&
              provider.movies.isNotEmpty) {
            final featuredMovie = provider.movies.first;
            final verticalMovies = provider.movies.skip(1).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === 1/3 SUPÉRIEUR (CONTENEUR DE SECOURS DE L'AFFICHE À LA UNE) ===
                  Stack(
                    children: [
                      // Image de fond à la une
                      Container(
                        height: screenSize.height * 0.50,
                        width: double.infinity,
                        color: const Color(0xFF1E1E1E),
                        child:
                            featuredMovie.posterUrl != null &&
                                featuredMovie.posterUrl!.isNotEmpty
                            ? Image.network(
                                provider.getImageUrl(featuredMovie.posterUrl),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Icon(
                                  Icons.movie,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              ),
                      ),

                      // Dégradé pour fusionner avec le fond
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xAA121212),
                                Color(0xFF121212),
                              ],
                              stops: [0.5, 0.8, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Infos du film à la une
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'À LA UNE',
                              style: TextStyle(
                                color: Color(0xFFE50914),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              featuredMovie.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFB703),
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  featuredMovie.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Color(0xFFFFB703),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // === BARRE DE CATÉGORIES HORIZONTALE ===
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final isSelected = selectedCategoryIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(categories[index]),
                              selected: isSelected,
                              selectedColor: const Color(0xFFE50914),
                              backgroundColor: const Color(0xFF2A2A2A),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white60,
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedCategoryIndex = index;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // === LISTE VERTICALE DES AUTRES FILMS (AVEC CONTENEURS ICÔNES DE LECTURE) ===
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
                    child: Text(
                      'Recommandés pour vous',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: verticalMovies.length,
                    itemBuilder: (context, index) {
                      final movie = verticalMovies[index];
                      // === DANS LE LISTVIEW.BUILDER, POUR CHAQUE FILM ===
                      return Card(
                        // ... vos autres propriétés Card
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          // UTILISATION DE ASPECTRATIO POUR CONTRÔLER STRICTEMENT LA TAILLE
                          leading: AspectRatio(
                            aspectRatio:
                                2 /
                                3, // 👈 Définit un ratio d'image vertical strict (Affiche de film)
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                color: const Color(
                                  0xFF2A2A2A,
                                ), // Fond de secours
                                child: movie.posterUrl?.isNotEmpty == true
                                    ? Image.network(
                                        provider.getImageUrl(movie.posterUrl),
                                        // IMPORTANT : BoxFit.cover pour remplir le ratio sans déformer
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              );
                                            },
                                      )
                                    : const Icon(
                                        Icons.movie,
                                        color: Color(0xFFFFB703),
                                      ),
                              ),
                            ),
                          ),
                          title: Text(
                            movie.title,
                            // ... vos styles de titre
                          ),
                          // ... le reste du ListTile
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Aucun film trouvé.'));
        },
      ),
    );
  }
}
