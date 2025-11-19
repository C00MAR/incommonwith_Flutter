import 'cart_item.dart';

enum OrderStatus { pending, confirmed, shipped, delivered }

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime createdAt;
  final OrderStatus status;
  final String userEmail;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    this.status = OrderStatus.pending,
    required this.userEmail,
  });

  String get statusDisplay {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.confirmed:
        return 'Confirmée';
      case OrderStatus.shipped:
        return 'Expédiée';
      case OrderStatus.delivered:
        return 'Livrée';
    }
  }

  String get formattedTotal => '${totalAmount.toStringAsFixed(2)} €';

  String get formattedDate =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year}';

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      userEmail: json['userEmail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'userEmail': userEmail,
    };
  }
}
