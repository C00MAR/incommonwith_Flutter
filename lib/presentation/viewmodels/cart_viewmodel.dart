import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import '../../data/repositories/cart_repository.dart';
import 'base_viewmodel.dart';

class CartViewModel extends BaseViewModel {
  final CartRepository _repository = CartRepository();
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemsCount =>
      _items.fold(0, (total, item) => total + item.quantity);
  double get totalAmount =>
      _items.fold(0.0, (total, item) => total + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  String get formattedTotal => '${totalAmount.toStringAsFixed(2)} €';

  CartViewModel() {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      _items = await _repository.loadCart();
      notifyListeners();
    } catch (e) {
      setError('Erreur chargement panier : $e');
    }
  }

  Future<void> addProduct(Product product, {int quantity = 1}) async {
    try {
      final existingIndex =
          _items.indexWhere((item) => item.product.id == product.id);

      if (existingIndex >= 0) {
        _items[existingIndex].quantity += quantity;
      } else {
        _items.add(CartItem(product: product, quantity: quantity));
      }

      await _repository.saveCart(_items);
      notifyListeners();
    } catch (e) {
      setError('Impossible d\'ajouter le produit : $e');
    }
  }

  Future<void> removeProduct(String productId) async {
    try {
      _items.removeWhere((item) => item.product.id == productId);
      await _repository.saveCart(_items);
      notifyListeners();
    } catch (e) {
      setError('Impossible de retirer le produit : $e');
    }
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeProduct(productId);
        return;
      }

      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index >= 0) {
        _items[index].quantity = newQuantity;
        await _repository.saveCart(_items);
        notifyListeners();
      }
    } catch (e) {
      setError('Impossible de modifier la quantité : $e');
    }
  }

  Future<void> clearCart() async {
    try {
      _items = [];
      await _repository.clearCart();
      notifyListeners();
    } catch (e) {
      setError('Impossible de vider le panier : $e');
    }
  }
}
