import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class CatalogRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  Future<List<Product>> fetchProducts() async {
    try {
      final cachedProducts = await _cacheService.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }

      final products = await _apiService.fetchProducts();
      await _cacheService.cacheProducts(products);
      return products;
    } catch (e) {
      final cachedProducts = await _cacheService.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      rethrow;
    }
  }

  Future<Product> fetchProduct(String id) async {
    final cached = await _cacheService.getCachedProductDetail(id);
    if (cached != null) {
      return cached;
    }

    final product = await _apiService.fetchProduct(id);
    await _cacheService.cacheProductDetail(product);
    return product;
  }

  Future<List<String>> fetchCategories() async {
    return await _apiService.fetchCategories();
  }

  Future<List<Product>> refreshProducts() async {
    await _cacheService.clearProductsCache();
    return await fetchProducts();
  }
}
