import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class CacheService {
  static const String _productsKey = 'cached_products';
  static const String _productDetailPrefix = 'product_detail_';
  static const String _cartKey = 'cart_items';
  static const String _ordersKey = 'orders';
  static const String _lastUpdateKey = 'last_products_update';
  static const Duration cacheValidity = Duration(hours: 1);

  Future<void> cacheProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_productsKey, jsonString);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  Future<List<Product>> getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateString = prefs.getString(_lastUpdateKey);

    if (lastUpdateString == null) return [];

    final lastUpdate = DateTime.parse(lastUpdateString);
    if (DateTime.now().difference(lastUpdate) > cacheValidity) return [];

    final jsonString = prefs.getString(_productsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> cacheProductDetail(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(product.toJson());
    await prefs.setString('$_productDetailPrefix${product.id}', jsonString);
  }

  Future<Product?> getCachedProductDetail(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('$_productDetailPrefix$id');
    if (jsonString == null) return null;

    final jsonData = json.decode(jsonString);
    return Product.fromJson(jsonData);
  }

  Future<void> cacheCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, jsonString);
  }

  Future<List<CartItem>> getCachedCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cartKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((json) => CartItem.fromJson(json)).toList();
  }

  Future<void> cacheOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final existingOrders = await getCachedOrders();
    existingOrders.add(order);

    final jsonString =
        json.encode(existingOrders.map((o) => o.toJson()).toList());
    await prefs.setString(_ordersKey, jsonString);
  }

  Future<List<Order>> getCachedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_ordersKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((json) => Order.fromJson(json)).toList();
  }

  Future<void> clearProductsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsKey);
    await prefs.remove(_lastUpdateKey);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
