import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.football-data.org/v4/';
  static const String apiKey = '6ee3696dc7f641d8a022ea6dba29ff4f';
}

class AppColors {
  // Thème Vert Terrain (Clair)
  static const Color primaryGreen = Color(0xFF1B5E20); // Vert pelouse officiel
  static const Color accentGold = Color(0xFFD4AF37); // Couleur coupe / trophée
  static const Color backgroundLight = Color(0xFFF5F6F8); // Fond d'écran clair
  static const Color cardLight = Colors.white; // Fond des cartes de match

  // Thème Stade de Nuit (Sombre)
  static const Color backgroundDark = Color(0xFF0F172A); // Bleu nuit profond
  static const Color cardDark = Color(
    0xFF1E293B,
  ); // Gris/Bleu ardoise pour les cartes
  static const Color liveRed = Color(
    0xFFEF4444,
  ); // Rouge clignotant pour les matchs en direct
}
