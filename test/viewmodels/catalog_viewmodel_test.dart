import 'package:flutter_test/flutter_test.dart';
import 'package:incommonwith_flutter/presentation/viewmodels/catalog_viewmodel.dart';

void main() {
  late CatalogViewModel viewModel;

  setUp(() {
    viewModel = CatalogViewModel();
  });

  group('CatalogViewModel Tests', () {
    test('loadProducts devrait initialiser le viewModel', () async {
      expect(viewModel.products, isEmpty);
    });

    test('searchProducts devrait mettre a jour searchQuery', () {
      viewModel.searchProducts('Laptop');
      expect(viewModel.searchQuery, equals('laptop'));
    });

    test('filterByCategory devrait mettre a jour selectedCategory', () {
      viewModel.filterByCategory('electronics');
      expect(viewModel.selectedCategory, equals('electronics'));
    });
  });
}
