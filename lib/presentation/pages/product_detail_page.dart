import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/app_menu_drawer.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Container(
              height: 1,
              color: Colors.black.withValues(alpha: 0.1),
            ),
            Expanded(
              child: Consumer<CatalogViewModel>(
                builder: (context, catalogViewModel, _) {
                  final product = catalogViewModel.getProductById(widget.productId);

                  if (product == null) {
                    return const Center(
                      child: Text('Produit non trouvé'),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.network(
                            product.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported, size: 100),
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                  color: Color(0xFF4A1D0F),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 24),

                              Row(
                                children: [
                                  const Text(
                                    'Quantity',
                                    style: TextStyle(
                                      color: Color(0xFF4A1D0F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  _buildQuantityButton(
                                    '-',
                                    () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      '$_quantity',
                                      style: const TextStyle(
                                        color: Color(0xFF4A1D0F),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  _buildQuantityButton(
                                    '+',
                                    () => setState(() => _quantity++),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              Row(
                                children: [
                                  const Text(
                                    'From ',
                                    style: TextStyle(
                                      color: Color(0xFF4A1D0F),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    product.formattedPrice,
                                    style: const TextStyle(
                                      color: Color(0xFF4A1D0F),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              Text(
                                product.description,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  height: 1.6,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 32),

                              if (!kIsWeb && Platform.isAndroid)
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Share.share(
                                        'Découvre ${product.title} à ${product.price}€ sur InCommonWith !',
                                        subject: product.title,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF4A1D0F),
                                      side: const BorderSide(
                                        color: Color(0xFF4A1D0F),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    icon: const Icon(Icons.share),
                                    label: const Text(
                                      'Share',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              if (!kIsWeb && Platform.isAndroid) const SizedBox(height: 16),

                              Consumer<CartViewModel>(
                                builder: (context, cartViewModel, _) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        for (int i = 0; i < _quantity; i++) {
                                          cartViewModel.addProduct(product);
                                        }
                                        context.go('/cart');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xFF4A1D0F),
                                        side: const BorderSide(
                                          color: Color(0xFF4A1D0F),
                                          width: 1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, _) {
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
      },
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

  Widget _buildQuantityButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4A1D0F), width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4A1D0F),
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
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
