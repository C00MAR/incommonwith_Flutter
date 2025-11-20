import '../../data/models/cart_item.dart';
import '../../data/models/order.dart';
import '../../data/services/cache_service.dart';
import 'base_viewmodel.dart';

class CheckoutViewModel extends BaseViewModel {
  final CacheService _cacheService;
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  CheckoutViewModel({CacheService? cacheService})
      : _cacheService = cacheService ?? CacheService() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      _orders = await _cacheService.getCachedOrders();
      notifyListeners();
    } catch (e) {
      setError('Erreur chargement commandes : $e');
    }
  }

  Future<Order?> processCheckout(
      List<CartItem> cartItems, String userEmail) async {
    if (cartItems.isEmpty) {
      setError('Le panier est vide');
      return null;
    }

    setLoading(true);
    clearError();

    try {
      final order = Order(
        id: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
        items: cartItems,
        totalAmount:
            cartItems.fold(0.0, (total, item) => total + item.totalPrice),
        createdAt: DateTime.now(),
        status: OrderStatus.pending,
        userEmail: userEmail,
      );

      await _cacheService.cacheOrder(order);
      _orders.add(order);
      notifyListeners();

      return order;
    } catch (e) {
      setError('Erreur lors de la création de la commande : $e');
      return null;
    } finally {
      setLoading(false);
    }
  }
}
