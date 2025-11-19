import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'core/config/app_providers.dart';
import 'core/config/app_router.dart';
import 'firebase_options.dart';

/// Point d'entrée de l'application
///
/// Configure Firebase, les providers et démarre l'application.
void main() async {
  // S'assure que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lance l'application
  runApp(const MyApp());
}

/// Widget racine de l'application
///
/// Configure les providers globaux et le routeur de navigation.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Configure tous les providers de l'application
      providers: AppProviders.getProviders(),
      child: MaterialApp.router(
        // Configuration de base
        title: 'InCommonWith',
        debugShowCheckedModeBanner: false,

        // Thème de l'application
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,

          // Configuration des composants
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),

        // Configuration du routeur
        routerConfig: AppRouter.router,
      ),
    );
  }
}
