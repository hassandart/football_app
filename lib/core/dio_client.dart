import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  // Remplacez cette valeur par votre véritable clé API TMDB (v3 auth)
  static const String _apiKey = 'd65be3c76897ac8db6580845eba08f02';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(
          seconds: 10,
        ), // 10 secondes max pour se connecter au serveur
        receiveTimeout: const Duration(
          seconds: 10,
        ), // 10 secondes max pour recevoir la réponse
        responseType: ResponseType.json,
      ),
    );

    // Ajout de l'intercepteur pour injecter automatiquement les paramètres requis
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ajoute systématiquement l'api_key et la langue à toutes les requêtes URL
          options.queryParameters.addAll({
            'api_key': _apiKey,
            'language': 'fr-FR',
          });

          return handler.next(options); // Continue la requête vers le serveur
        },
        onResponse: (response, handler) {
          // Vous pouvez intercepter et logguer les réponses ici si besoin en développement
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Centralisation de la gestion des messages d'erreur réseau
          String errorMessage = 'Une erreur réseau inconnue est survenue.';

          switch (e.type) {
            case DioExceptionType.connectionTimeout:
              errorMessage =
                  'Connexion au serveur expirée. Vérifiez votre réseau.';
              break;
            case DioExceptionType.receiveTimeout:
              errorMessage = 'Le serveur met trop de temps à répondre.';
              break;
            case DioExceptionType.badResponse:
              final statusCode = e.response?.statusCode;
              if (statusCode == 401) {
                errorMessage = 'Clé API invalide ou expirée.';
              } else if (statusCode == 404) {
                errorMessage = 'Ressource introuvable sur le serveur.';
              } else {
                errorMessage =
                    'Erreur serveur ($statusCode). Veuillez réessayer.';
              }
              break;
            case DioExceptionType.connectionError:
              errorMessage = 'Aucune connexion internet détectée.';
              break;
            default:
              errorMessage = 'Erreur de requête : ${e.message}';
          }

          // On renvoie une exception personnalisée propre
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: errorMessage,
              type: e.type,
            ),
          );
        },
      ),
    );
  }
}
