import '../models/cart_item.dart';
import '../services/cache_service.dart';

class CartRepository {
  final CacheService _cacheService = CacheService();

  Future<List<CartItem>> loadCart() async {
    try {
      return await _cacheService.getCachedCart();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveCart(List<CartItem> items) async {
    await _cacheService.cacheCart(items);
  }

  Future<void> clearCart() async {
    await _cacheService.clearCart();
  }
}
