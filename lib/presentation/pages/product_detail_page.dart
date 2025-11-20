import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Consumer<CatalogViewModel>(
        builder: (context, catalogViewModel, _) {
          final product = catalogViewModel.getProductById(productId);

          if (product == null) {
            return const Center(
              child: Text('Produit non trouve'),
            );
          }

          return Column(
            children: [
              Image.network(product.thumbnail),
              Text(product.title),
              Text(product.formattedPrice),
              Text(product.description),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Consumer2<CatalogViewModel, CartViewModel>(
        builder: (context, catalogViewModel, cartViewModel, _) {
          final product = catalogViewModel.getProductById(productId);

          if (product == null) {
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!kIsWeb && Platform.isAndroid)
                FloatingActionButton(
                  onPressed: () {
                    Share.share(
                      'Découvre ${product.title} à ${product.price}€ sur InCommonWith !',
                      subject: product.title,
                    );
                  },
                  heroTag: 'share',
                  child: const Icon(Icons.share),
                ),
              if (!kIsWeb && Platform.isAndroid) const SizedBox(height: 8),
              FloatingActionButton.extended(
                onPressed: () {
                  cartViewModel.addProduct(product);
                  context.go('/cart');
                },
                heroTag: 'add_to_cart',
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Ajouter au panier'),
              ),
            ],
          );
        },
      ),
    );
  }
}
