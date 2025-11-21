# ShopFlutter

Application e-commerce en Flutter avec architecture MVVM.

Frontend inspiré du design de [InCommonWith](https://www.incommonwith.com/)

## Déploiement
**URL de production:** https://incommonwith-flutter.vercel.app/

## Features
- Catalogue produits avec recherche/filtre
- Panier avec gestion quantités
- Checkout et historique commandes
- Authentification Firebase (Email/Password + Google Sign-In)
- Support multi-plateforme (Web, iOS, Android)
- PWA avec installation possible

## Architecture
- MVVM (Model-View-ViewModel)
- Provider pour state management
- go_router pour la navigation
- Repository pattern
- Cache local avec SharedPreferences

## Spécificités plateformes
- **Web:** PWA avec manifest et bouton d'installation
- **Android:** Fonctionnalité de partage via share_plus
- **iOS:** Interface Cupertino pour la page Account

## Installation
```bash
flutter pub get
flutter run
```

### ⚙️ Configuration Google Sign-In
Pour activer l'authentification Google, suivez le guide détaillé :
📖 **[Guide de configuration Google Sign-In](GOOGLE_SIGNIN_SETUP.md)**

Ce guide couvre :
- Configuration Firebase Console (activation du provider Google)
- Configuration Android (SHA-1/SHA-256, google-services.json)
- Configuration iOS (GoogleService-Info.plist, URL schemes)
- Configuration Web (Web Client ID, domaines autorisés)
- Tests et résolution de problèmes

## Tests
```bash
flutter test --coverage
```

**Statistiques :**
- ✅ 26 tests (4 viewmodels + 1 model + 1 repository + 2 widgets)
- ✅ Coverage généré dans `coverage/lcov.info`

## Technologies
- Flutter 3.24.0
- Firebase Auth
- Fake Store API
- Provider
- go_router
