import 'package:flutter/foundation.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

/// ViewModel pour la gestion du catalogue de produits
///
/// Ce ViewModel gère l'état de l'écran du catalogue et coordonne
/// les interactions entre la vue et la couche domaine.
///
/// Utilise ChangeNotifier pour notifier la vue des changements d'état.
/// Suit le pattern MVVM (Model-View-ViewModel).
class CatalogViewModel extends ChangeNotifier {
  /// Use case pour récupérer les produits
  final GetProductsUseCase getProductsUseCase;

  /// Use case pour rechercher des produits
  final SearchProductsUseCase searchProductsUseCase;

  /// Liste des produits affichés
  List<Product> _products = [];

  /// Indique si les données sont en cours de chargement
  bool _isLoading = false;

  /// Message d'erreur en cas d'échec
  String? _errorMessage;

  /// Terme de recherche actuel
  String _searchQuery = '';

  /// Constructeur avec injection des use cases
  CatalogViewModel({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
  });

  // Getters pour exposer l'état de manière immutable
  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasError => _errorMessage != null;
  bool get hasProducts => _products.isNotEmpty;

  /// Charge la liste des produits
  ///
  /// Met à jour l'état de chargement et gère les erreurs.
  /// Notifie les listeners à chaque changement d'état.
  Future<void> loadProducts() async {
    // Début du chargement
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Exécute le use case pour récupérer les produits
      _products = await getProductsUseCase.execute();
      _errorMessage = null;
    } catch (e) {
      // Gestion des erreurs
      _errorMessage = 'Erreur lors du chargement des produits: ${e.toString()}';
      _products = [];

      if (kDebugMode) {
        print('❌ Erreur CatalogViewModel: $e');
      }
    } finally {
      // Fin du chargement
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recherche des produits par terme
  ///
  /// [query] Le terme de recherche
  ///
  /// Met à jour la liste des produits avec les résultats de la recherche.
  Future<void> searchProducts(String query) async {
    _searchQuery = query;

    // Si la recherche est vide, recharge tous les produits
    if (query.trim().isEmpty) {
      await loadProducts();
      return;
    }

    // Début de la recherche
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Exécute le use case de recherche
      _products = await searchProductsUseCase.execute(query);
      _errorMessage = null;
    } catch (e) {
      // Gestion des erreurs
      _errorMessage = 'Erreur lors de la recherche: ${e.toString()}';
      _products = [];

      if (kDebugMode) {
        print('❌ Erreur recherche: $e');
      }
    } finally {
      // Fin de la recherche
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Rafraîchit la liste des produits
  ///
  /// Utile pour le pull-to-refresh.
  Future<void> refresh() async {
    _searchQuery = '';
    await loadProducts();
  }

  /// Réinitialise l'état du ViewModel
  void reset() {
    _products = [];
    _isLoading = false;
    _errorMessage = null;
    _searchQuery = '';
    notifyListeners();
  }

  @override
  void dispose() {
    // Nettoie les ressources si nécessaire
    super.dispose();
  }
}
