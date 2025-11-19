import '../../domain/entities/product.dart';

/// Modèle Product - Représentation de la couche data
///
/// Cette classe étend l'entité Product du domaine et ajoute
/// la logique de sérialisation/désérialisation pour communiquer
/// avec l'API et la base de données.
///
/// Le modèle suit le pattern Repository et permet de convertir
/// les données JSON en entités du domaine et vice-versa.
class ProductModel extends Product {
  /// Constructeur du modèle ProductModel
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.stock,
    super.isOnSale,
    super.salePrice,
  });

  /// Factory constructor pour créer un ProductModel depuis JSON
  ///
  /// Utilisé pour désérialiser les données reçues de l'API
  ///
  /// Exemple de JSON attendu:
  /// ```json
  /// {
  ///   "id": "1",
  ///   "name": "iPhone 15",
  ///   "description": "Dernier iPhone",
  ///   "price": 999.99,
  ///   "imageUrl": "https://...",
  ///   "category": "Electronics",
  ///   "stock": 10,
  ///   "isOnSale": true,
  ///   "salePrice": 899.99
  /// }
  /// ```
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Product',
      description: json['description']?.toString() ?? '',
      price: _parseDouble(json['price']),
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      stock: _parseInt(json['stock']),
      isOnSale: json['isOnSale'] == true || json['is_on_sale'] == true,
      salePrice: json['salePrice'] != null || json['sale_price'] != null
          ? _parseDouble(json['salePrice'] ?? json['sale_price'])
          : null,
    );
  }

  /// Convertit le modèle en Map pour la sérialisation JSON
  ///
  /// Utilisé pour envoyer les données à l'API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'isOnSale': isOnSale,
      if (salePrice != null) 'salePrice': salePrice,
    };
  }

  /// Crée un ProductModel depuis une entité Product du domaine
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
      stock: product.stock,
      isOnSale: product.isOnSale,
      salePrice: product.salePrice,
    );
  }

  /// Convertit le modèle en entité du domaine
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      category: category,
      stock: stock,
      isOnSale: isOnSale,
      salePrice: salePrice,
    );
  }

  /// Helper: Parse un double depuis n'importe quel type
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Helper: Parse un int depuis n'importe quel type
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    int? stock,
    bool? isOnSale,
    double? salePrice,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      isOnSale: isOnSale ?? this.isOnSale,
      salePrice: salePrice ?? this.salePrice,
    );
  }
}
