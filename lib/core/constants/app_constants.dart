/// Constantes globales de l'application
///
/// Ce fichier centralise toutes les constantes utilisées dans l'application
/// pour faciliter la maintenance et éviter la duplication.
class AppConstants {
  // Constructeur privé pour empêcher l'instanciation
  AppConstants._();

  /// Configuration API
  static const String apiBaseUrl = 'http://localhost:3000/api';
  static const int apiTimeout = 30; // en secondes

  /// Configuration de l'application
  static const String appName = 'InCommonWith';
  static const String appVersion = '1.0.0';

  /// Clés de stockage local
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyCartItems = 'cart_items';

  /// Délais et timeouts
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration loadingDelay = Duration(milliseconds: 500);

  /// Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Messages d'erreur
  static const String errorNetwork = 'Erreur de connexion réseau';
  static const String errorUnknown = 'Une erreur est survenue';
  static const String errorTimeout = 'La requête a expiré';
  static const String errorNotFound = 'Ressource non trouvée';
  static const String errorUnauthorized = 'Non autorisé';
  static const String errorServerError = 'Erreur serveur';

  /// Messages de succès
  static const String successLogin = 'Connexion réussie';
  static const String successRegister = 'Inscription réussie';
  static const String successLogout = 'Déconnexion réussie';
  static const String successUpdate = 'Mise à jour réussie';

  /// Routes (noms des routes pour la navigation)
  static const String routeHome = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeCatalog = '/catalog';
  static const String routeProductDetail = '/product/:id';
  static const String routeCart = '/cart';
  static const String routeCheckout = '/checkout';
  static const String routeOrders = '/orders';
  static const String routeOrderDetail = '/order/:id';
  static const String routeProfile = '/profile';

  /// Regex patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp phoneRegex = RegExp(
    r'^[+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$',
  );
}
