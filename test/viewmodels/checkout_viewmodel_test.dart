import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:incommonwith_flutter/presentation/viewmodels/checkout_viewmodel.dart';
import 'package:incommonwith_flutter/data/models/cart_item.dart';
import 'package:incommonwith_flutter/data/models/product.dart';
import 'package:incommonwith_flutter/data/models/order.dart';
import 'package:incommonwith_flutter/data/services/cache_service.dart';

// Générer les mocks avec : flutter pub run build_runner build
@GenerateMocks([CacheService])
import 'checkout_viewmodel_test.mocks.dart';

void main() {
  late CheckoutViewModel checkoutViewModel;
  late MockCacheService mockCacheService;

  setUp(() {
    mockCacheService = MockCacheService();

    // Mock getCachedOrders to return empty list by default
    when(mockCacheService.getCachedOrders()).thenAnswer((_) async => []);

    checkoutViewModel = CheckoutViewModel(cacheService: mockCacheService);
  });

  group('CheckoutViewModel Tests', () {
    test('processCheckout devrait créer une commande avec panier non vide',
        () async {
      // Arrange
      final product = Product(
        id: '1',
        title: 'Test Product',
        price: 29.99,
        thumbnail: 'https://test.com/image.jpg',
        images: ['https://test.com/image.jpg'],
        description: 'Test Description',
        category: 'Test Category',
      );
      final cartItem = CartItem(product: product, quantity: 2);
      final cartItems = [cartItem];
      const userEmail = 'test@test.com';

      when(mockCacheService.cacheOrder(any)).thenAnswer((_) async => {});

      // Act
      final order =
          await checkoutViewModel.processCheckout(cartItems, userEmail);

      // Assert
      expect(order, isNotNull);
      expect(order!.items.length, 1);
      expect(order.totalAmount, 59.98); // 29.99 * 2
      expect(order.userEmail, userEmail);
      expect(order.status, OrderStatus.pending);
      expect(checkoutViewModel.errorMessage, isEmpty);
      expect(checkoutViewModel.hasError, isFalse);
      verify(mockCacheService.cacheOrder(any)).called(1);
    });

    test('processCheckout devrait échouer si panier vide', () async {
      // Arrange
      final cartItems = <CartItem>[];
      const userEmail = 'test@test.com';

      // Act
      final order =
          await checkoutViewModel.processCheckout(cartItems, userEmail);

      // Assert
      expect(order, isNull);
      expect(checkoutViewModel.hasError, isTrue);
      expect(checkoutViewModel.errorMessage, contains('Le panier est vide'));
      verifyNever(mockCacheService.cacheOrder(any));
    });
  });
}
