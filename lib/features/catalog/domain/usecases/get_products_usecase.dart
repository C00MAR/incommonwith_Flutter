import '../entities/product.dart';
import '../repositories/catalog_repository.dart';

/// Use Case: Récupérer la liste des produits
///
/// Ce use case encapsule la logique métier pour récupérer
/// la liste complète des produits du catalogue.
///
/// Les use cases suivent le principe de responsabilité unique (SRP)
/// et isolent chaque action métier dans une classe dédiée.
class GetProductsUseCase {
  /// Repository pour accéder aux données du catalogue
  final CatalogRepository repository;

  /// Constructeur avec injection du repository
  GetProductsUseCase(this.repository);

  /// Exécute le use case
  ///
  /// Retourne un Future contenant la liste de tous les produits.
  /// Lance une exception en cas d'erreur.
  Future<List<Product>> execute() async {
    return await repository.getProducts();
  }
}
