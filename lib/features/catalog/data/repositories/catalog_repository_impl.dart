import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../models/product_model.dart';

/// Implémentation du CatalogRepository
///
/// Cette classe implémente l'interface CatalogRepository définie dans le domaine.
/// Elle gère la communication avec l'API backend pour récupérer les données
/// des produits.
///
/// Utilise le package http pour effectuer les requêtes REST.
class CatalogRepositoryImpl implements CatalogRepository {
  /// Client HTTP pour effectuer les requêtes
  final http.Client client;

  /// URL de base de l'API
  final String baseUrl;

  /// Constructeur avec injection de dépendances
  ///
  /// [client] Le client HTTP à utiliser (permet le mocking pour les tests)
  /// [baseUrl] L'URL de base de l'API (par défaut: localhost:3000)
  CatalogRepositoryImpl({
    http.Client? client,
    this.baseUrl = 'http://localhost:3000/api',
  }) : client = client ?? http.Client();

  @override
  Future<List<Product>> getProducts() async {
    try {
      // Effectue la requête GET vers l'API
      final response = await client.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      // Vérifie le code de statut HTTP
      if (response.statusCode == 200) {
        // Décode le JSON et convertit en liste de produits
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => ProductModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
      }
    } catch (e) {
      // Propage l'erreur avec un message descriptif
      throw Exception('Erreur réseau lors de la récupération des produits: $e');
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ProductModel.fromJson(json).toEntity();
      } else if (response.statusCode == 404) {
        // Produit non trouvé
        return null;
      } else {
        throw Exception(
            'Erreur lors de la récupération du produit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau lors de la récupération du produit: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products?category=$category'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => ProductModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
            'Erreur lors de la récupération des produits par catégorie: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Erreur réseau lors de la récupération des produits par catégorie: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/search?q=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => ProductModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
            'Erreur lors de la recherche de produits: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau lors de la recherche de produits: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((item) => item.toString()).toList();
      } else {
        throw Exception(
            'Erreur lors de la récupération des catégories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Erreur réseau lors de la récupération des catégories: $e');
    }
  }

  /// Libère les ressources du client HTTP
  void dispose() {
    client.close();
  }
}
