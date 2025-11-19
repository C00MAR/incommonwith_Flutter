class Product {
  final String id;
  final String title;
  final double price;
  final String thumbnail;
  final List<String> images;
  final String description;
  final String category;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.description,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      thumbnail: json['image'] ?? '',
      images: [json['image'] ?? ''],
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': thumbnail,
      'description': description,
      'category': category,
    };
  }

  String get formattedPrice => '${price.toStringAsFixed(2)} €';
}
