import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/app_menu_drawer.dart';
import '../widgets/pwa_install_button.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool _filtersExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final catalogViewModel = Provider.of<CatalogViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, cartViewModel),

            Container(
              height: 1,
              color: Colors.black.withValues(alpha: 0.1),
            ),

            _buildFilterButton(),

            if (_filtersExpanded)
              Container(
                height: 1,
                color: Colors.black.withValues(alpha: 0.1),
              ),

            if (_filtersExpanded) _buildFiltersSection(catalogViewModel),

            if (_filtersExpanded)
              Container(
                height: 1,
                color: Colors.black.withValues(alpha: 0.1),
              ),

            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'All Product',
                              style: TextStyle(
                                fontFamily: 'Mier',
                                color: Color(0xFF4A1D0F),
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: '${catalogViewModel.productsCount}',
                              style: TextStyle(
                                fontFamily: 'Mier',
                                color: Color(0xFF4A1D0F).withValues(alpha: 0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Grille de produits
                  if (catalogViewModel.isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4A1D0F),
                        ),
                      ),
                    )
                  else if (catalogViewModel.hasError)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          catalogViewModel.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  else if (catalogViewModel.products.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Aucun produit trouvé',
                          style: TextStyle(
                            color: Color(0xFF4A1D0F),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = catalogViewModel.products[index];
                            return _buildProductCard(product);
                          },
                          childCount: catalogViewModel.products.length,
                        ),
                      ),
                    ),

                  /// Espacement en bas
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CartViewModel cartViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => context.go('/home'),
            child: const Text(
              'In Common With',
              style: TextStyle(
                color: Color(0xFF4A1D0F),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Row(
            children: [
              _buildHeaderButton(
                '${cartViewModel.itemsCount}',
                () => context.push('/cart'),
              ),
              const PWAInstallButton(),
              const SizedBox(width: 8),
              _buildHeaderButton(
                'Menu',
                () => _showFullScreenMenu(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4A1D0F), width: 1),
          color: Colors.transparent,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A1D0F),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _filtersExpanded = !_filtersExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _filtersExpanded ? '- Filter' : '+ Filter',
              style: const TextStyle(
                color: Color(0xFF4A1D0F),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(CatalogViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Colonne Categories
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    color: Color(0xFF4A1D0F),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                ...viewModel.categories.map((category) {
                  final isSelected = viewModel.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () {
                        viewModel.filterByCategory(isSelected ? '' : category);
                      },
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF4A1D0F)
                              : const Color(0xFF4A1D0F).withValues(alpha: 0.6),
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(width: 48),

          /// Colonne Search
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search',
                  style: TextStyle(
                    color: Color(0xFF4A1D0F),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    viewModel.searchProducts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF4A1D0F).withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF4A1D0F),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.zero,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A1D0F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return InkWell(
      onTap: () {
        context.push('/product/${product.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image du produit
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: product.thumbnail.isNotEmpty
                  ? Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.lightbulb_outline,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          /// Titre du produit
          Text(
            product.title,
            style: const TextStyle(
              color: Color(0xFF4A1D0F),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          /// Prix
          Text(
            product.formattedPrice,
            style: const TextStyle(
              color: Color(0xFF4A1D0F),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenMenu(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) => const AppMenuDrawer(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }
}
