/// Entité Product - Représentation pure du domaine
///
/// Cette classe représente un produit dans le domaine métier.
/// Elle ne contient aucune logique de sérialisation/désérialisation.
/// Les entités sont des objets immuables qui représentent les concepts
/// fondamentaux du domaine métier.
class Product {
  /// Identifiant unique du produit
  final String id;

  /// Nom du produit
  final String name;

  /// Description détaillée du produit
  final String description;

  /// Prix du produit en euros
  final double price;

  /// URL de l'image du produit
  final String imageUrl;

  /// Catégorie du produit (ex: "Electronics", "Clothing", etc.)
  final String category;

  /// Quantité disponible en stock
  final int stock;

  /// Indique si le produit est en promotion
  final bool isOnSale;

  /// Prix promotionnel (si isOnSale est true)
  final double? salePrice;

  /// Constructeur de l'entité Product
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.isOnSale = false,
    this.salePrice,
  });

  /// Retourne le prix effectif à afficher (prix normal ou promotionnel)
  double get effectivePrice => isOnSale && salePrice != null ? salePrice! : price;

  /// Indique si le produit est disponible en stock
  bool get isAvailable => stock > 0;

  /// Calcule le pourcentage de réduction si le produit est en promotion
  int? get discountPercentage {
    if (!isOnSale || salePrice == null) return null;
    return (((price - salePrice!) / price) * 100).round();
  }

  /// Crée une copie de l'entité avec des valeurs modifiées
  Product copyWith({
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
    return Product(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, stock: $stock)';
  }
}
