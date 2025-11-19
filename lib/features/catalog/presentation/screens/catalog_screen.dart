import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/catalog_viewmodel.dart';
import '../widgets/product_card.dart';

/// Écran principal du catalogue de produits
///
/// Affiche la liste complète des produits disponibles avec possibilité
/// de recherche et de rafraîchissement.
///
/// Utilise Provider pour accéder au CatalogViewModel et réagir aux
/// changements d'état.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  /// Contrôleur pour le champ de recherche
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Charge les produits au démarrage de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatalogViewModel>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Gère la recherche de produits
  void _handleSearch(String query) {
    context.read<CatalogViewModel>().searchProducts(query);
  }

  /// Gère le rafraîchissement de la liste
  Future<void> _handleRefresh() async {
    _searchController.clear();
    await context.read<CatalogViewModel>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: Consumer<CatalogViewModel>(
        builder: (context, viewModel, child) {
          // Affiche un indicateur de chargement
          if (viewModel.isLoading && !viewModel.hasProducts) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Affiche un message d'erreur
          if (viewModel.hasError && !viewModel.hasProducts) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage ?? 'Une erreur est survenue',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.loadProducts,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          // Affiche un message si aucun produit n'est trouvé
          if (!viewModel.hasProducts) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.searchQuery.isEmpty
                        ? 'Aucun produit disponible'
                        : 'Aucun produit trouvé pour "${viewModel.searchQuery}"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Affiche la liste des produits
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: viewModel.products.length,
              itemBuilder: (context, index) {
                final product = viewModel.products[index];
                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
    );
  }

  /// Construit la barre de recherche
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Rechercher un produit...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _handleSearch('');
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      onChanged: _handleSearch,
    );
  }
}
