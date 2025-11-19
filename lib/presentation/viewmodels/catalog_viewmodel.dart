import '../../data/models/product.dart';
import '../../data/repositories/catalog_repository.dart';
import 'base_viewmodel.dart';

class CatalogViewModel extends BaseViewModel {
  final CatalogRepository _repository = CatalogRepository();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = '';
  String _searchQuery = '';

  List<Product> get products =>
      _filteredProducts.isEmpty ? _allProducts : _filteredProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int get productsCount => products.length;

  CatalogViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    await loadProducts();
    await loadCategories();
  }

  Future<void> loadProducts() async {
    if (isLoading) return;
    setLoading(true);
    clearError();
    try {
      _allProducts = await _repository.fetchProducts();
      _applyFilters();
    } catch (e) {
      setError('Impossible de charger les produits : $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _repository.fetchCategories();
      notifyListeners();
    } catch (e) {
      // Ne pas afficher d'erreur pour les catégories
    }
  }

  Future<void> refreshProducts() async {
    setLoading(true);
    clearError();
    try {
      _allProducts = await _repository.refreshProducts();
      _applyFilters();
    } catch (e) {
      setError('Impossible de rafraîchir : $e');
    } finally {
      setLoading(false);
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      bool matchesCategory = _selectedCategory.isEmpty ||
          _selectedCategory == 'all' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();

      bool matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearFilters() {
    _selectedCategory = '';
    _searchQuery = '';
    _filteredProducts = [];
    notifyListeners();
  }
}
