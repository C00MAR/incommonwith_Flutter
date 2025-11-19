import '../entities/product.dart';

/// Interface du repository Catalog
///
/// Définit le contrat pour accéder aux données du catalogue de produits.
/// Cette interface fait partie de la couche domaine et ne dépend d'aucune
/// implémentation concrète (API, base de données, etc.).
///
/// L'implémentation concrète se trouve dans la couche data.
abstract class CatalogRepository {
  /// Récupère la liste complète des produits
  ///
  /// Retourne un Future contenant la liste de tous les produits disponibles.
  /// Lance une exception en cas d'erreur réseau ou serveur.
  Future<List<Product>> getProducts();

  /// Récupère un produit spécifique par son ID
  ///
  /// [id] L'identifiant unique du produit à récupérer
  ///
  /// Retourne un Future contenant le produit correspondant.
  /// Retourne null si le produit n'existe pas.
  /// Lance une exception en cas d'erreur réseau ou serveur.
  Future<Product?> getProductById(String id);

  /// Récupère les produits d'une catégorie spécifique
  ///
  /// [category] La catégorie des produits à récupérer
  ///
  /// Retourne un Future contenant la liste des produits de cette catégorie.
  /// Lance une exception en cas d'erreur réseau ou serveur.
  Future<List<Product>> getProductsByCategory(String category);

  /// Recherche des produits par nom
  ///
  /// [query] Le terme de recherche
  ///
  /// Retourne un Future contenant la liste des produits correspondants.
  /// Lance une exception en cas d'erreur réseau ou serveur.
  Future<List<Product>> searchProducts(String query);

  /// Récupère les catégories disponibles
  ///
  /// Retourne un Future contenant la liste de toutes les catégories.
  /// Lance une exception en cas d'erreur réseau ou serveur.
  Future<List<String>> getCategories();
}
