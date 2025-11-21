import 'package:flutter_test/flutter_test.dart';
import 'package:incommonwith_flutter/data/models/order.dart';
import 'package:incommonwith_flutter/data/models/cart_item.dart';
import 'package:incommonwith_flutter/data/models/product.dart';

void main() {
  group('Order Model Tests', () {
    late Product testProduct;
    late CartItem testCartItem;
    late Order testOrder;

    setUp(() {
      testProduct = const Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        thumbnail: 'https://test.com/image.jpg',
        images: ['https://test.com/image.jpg'],
        description: 'Test description',
        category: 'electronics',
      );

      testCartItem = CartItem(product: testProduct, quantity: 2);

      testOrder = Order(
        id: 'ORDER_123',
        items: [testCartItem],
        totalAmount: 59.98,
        createdAt: DateTime(2025, 1, 15),
        status: OrderStatus.pending,
        userEmail: 'test@example.com',
      );
    });

    test('devrait créer un Order correctement', () {
      expect(testOrder.id, 'ORDER_123');
      expect(testOrder.items.length, 1);
      expect(testOrder.totalAmount, 59.98);
      expect(testOrder.status, OrderStatus.pending);
      expect(testOrder.userEmail, 'test@example.com');
    });

    test('statusDisplay devrait retourner le texte correct', () {
      expect(testOrder.statusDisplay, 'En attente');

      final confirmedOrder = Order(
        id: 'ORDER_124',
        items: [testCartItem],
        totalAmount: 59.98,
        createdAt: DateTime.now(),
        status: OrderStatus.confirmed,
        userEmail: 'test@example.com',
      );
      expect(confirmedOrder.statusDisplay, 'Confirmée');
    });

    test('formattedTotal devrait formater correctement le montant', () {
      expect(testOrder.formattedTotal, '59.98 €');
    });

    test('formattedDate devrait formater correctement la date', () {
      expect(testOrder.formattedDate, '15/1/2025');
    });

    test('toJson devrait convertir Order en Map', () {
      final json = testOrder.toJson();

      expect(json['id'], 'ORDER_123');
      expect(json['items'], isA<List>());
      expect(json['totalAmount'], 59.98);
      expect(json['status'], 'pending');
      expect(json['userEmail'], 'test@example.com');
    });

    test('fromJson devrait créer Order depuis Map', () {
      final json = {
        'id': 'ORDER_125',
        'items': [
          {
            'product': {
              'id': '1',
              'title': 'Test Product',
              'price': 29.99,
              'image': 'https://test.com/image.jpg',
              'description': 'Test description',
              'category': 'electronics',
            },
            'quantity': 2,
          }
        ],
        'totalAmount': 59.98,
        'createdAt': '2025-01-15T10:00:00.000Z',
        'status': 'confirmed',
        'userEmail': 'test@example.com',
      };

      final order = Order.fromJson(json);

      expect(order.id, 'ORDER_125');
      expect(order.items.length, 1);
      expect(order.totalAmount, 59.98);
      expect(order.status, OrderStatus.confirmed);
      expect(order.userEmail, 'test@example.com');
    });

    test('fromJson devrait utiliser pending par défaut pour status invalide', () {
      final json = {
        'id': 'ORDER_126',
        'items': [
          {
            'product': {
              'id': '1',
              'title': 'Test Product',
              'price': 29.99,
              'image': 'https://test.com/image.jpg',
              'description': 'Test description',
              'category': 'electronics',
            },
            'quantity': 1,
          }
        ],
        'totalAmount': 29.99,
        'createdAt': '2025-01-15T10:00:00.000Z',
        'status': 'invalid_status',
        'userEmail': 'test@example.com',
      };

      final order = Order.fromJson(json);
      expect(order.status, OrderStatus.pending);
    });
  });
}
