import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

/// Widget Card pour afficher un produit dans la grille du catalogue
///
/// Affiche l'image, le nom, le prix et les informations de promotion
/// du produit de manière compacte et attractive.
class ProductCard extends StatelessWidget {
  /// Le produit à afficher
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navigation vers l'écran de détail du produit
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Produit sélectionné: ${product.name}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Expanded(
              flex: 3,
              child: _buildProductImage(),
            ),

            // Informations du produit
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nom du produit
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Prix et badge de promotion
                    _buildPriceSection(),

                    // Indicateur de stock
                    _buildStockIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit l'image du produit avec badge de promotion si applicable
  Widget _buildProductImage() {
    return Stack(
      children: [
        // Image du produit
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Icon(
                      Icons.shopping_bag,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ),

        // Badge de promotion
        if (product.isOnSale && product.discountPercentage != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-${product.discountPercentage}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Construit la section des prix avec prix barré si en promotion
  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prix promotionnel ou normal
        Text(
          '${product.effectivePrice.toStringAsFixed(2)} €',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: product.isOnSale ? Colors.red : Colors.black,
          ),
        ),

        // Prix original barré si en promotion
        if (product.isOnSale && product.salePrice != null)
          Text(
            '${product.price.toStringAsFixed(2)} €',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  /// Construit l'indicateur de disponibilité en stock
  Widget _buildStockIndicator() {
    if (!product.isAvailable) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Rupture de stock',
          style: TextStyle(
            fontSize: 10,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (product.stock < 5) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Derniers articles (${product.stock})',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
