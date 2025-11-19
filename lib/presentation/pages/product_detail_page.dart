import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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
              Consumer<CartViewModel>(
                builder: (context, cartViewModel, _) {
                  return ElevatedButton(
                    onPressed: () {
                      cartViewModel.addProduct(product);
                      context.go('/cart');
                    },
                    child: const Text('Ajouter au panier'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
