import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/catalog/presentation/screens/catalog_screen.dart';
import '../constants/app_constants.dart';

/// Configuration du routeur de l'application
///
/// Utilise go_router pour gérer la navigation dans l'application.
/// Définit toutes les routes et leurs configurations.
class AppRouter {
  // Constructeur privé pour empêcher l'instanciation
  AppRouter._();

  /// Instance du routeur configuré
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.routeCatalog,
    debugLogDiagnostics: true,
    routes: [
      // Route: Page d'accueil / Catalogue
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        builder: (context, state) => const CatalogScreen(),
      ),

      // Route: Catalogue de produits
      GoRoute(
        path: AppConstants.routeCatalog,
        name: 'catalog',
        builder: (context, state) => const CatalogScreen(),
      ),

      // Route: Connexion
      GoRoute(
        path: AppConstants.routeLogin,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Route: Inscription
      GoRoute(
        path: AppConstants.routeRegister,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // TODO: Ajouter les routes suivantes:
      // - Product detail
      // - Cart
      // - Checkout
      // - Orders
      // - Order detail
      // - Profile
    ],

    // Gestion des erreurs de navigation
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Erreur'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée: ${state.uri}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.routeHome),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),

    // Redirection conditionnelle (ex: vérifier l'authentification)
    redirect: (context, state) {
      // TODO: Implémenter la logique de redirection selon l'état d'authentification
      // Par exemple:
      // - Si non authentifié et route protégée -> rediriger vers /login
      // - Si authentifié et sur /login -> rediriger vers /catalog

      return null; // Pas de redirection pour l'instant
    },
  );
}
