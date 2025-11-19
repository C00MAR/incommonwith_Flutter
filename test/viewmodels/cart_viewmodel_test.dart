import 'package:flutter_test/flutter_test.dart';
import 'package:incommonwith_flutter/data/models/product.dart';
import 'package:incommonwith_flutter/presentation/viewmodels/cart_viewmodel.dart';

void main() {
  late CartViewModel viewModel;

  setUp(() {
    viewModel = CartViewModel();
  });

  group('CartViewModel Tests', () {
    test('addProduct devrait ajouter un produit', () async {
      final product = Product(
        id: '1',
        title: 'Test Product',
        price: 100.0,
        thumbnail: 'image.jpg',
        images: ['image.jpg'],
        description: 'Test description',
        category: 'test',
      );

      final initialLength = viewModel.items.length;
      await viewModel.addProduct(product);

      expect(viewModel.items.length, greaterThan(initialLength));
    });

    test('totalAmount devrait calculer le total', () async {
      expect(viewModel.totalAmount, equals(0.0));
    });
  });
}
