import '../entities/product.dart';
import '../repositories/catalog_repository.dart';

/// Use Case: Rechercher des produits
///
/// Ce use case encapsule la logique métier pour rechercher
/// des produits par nom ou mots-clés.
class SearchProductsUseCase {
  /// Repository pour accéder aux données du catalogue
  final CatalogRepository repository;

  /// Constructeur avec injection du repository
  SearchProductsUseCase(this.repository);

  /// Exécute le use case
  ///
  /// [query] Le terme de recherche
  ///
  /// Retourne un Future contenant la liste des produits correspondants.
  /// Retourne une liste vide si la requête est vide.
  /// Lance une exception en cas d'erreur.
  Future<List<Product>> execute(String query) async {
    // Validation: ne pas effectuer de recherche si la requête est vide
    if (query.trim().isEmpty) {
      return [];
    }

    return await repository.searchProducts(query);
  }
}
