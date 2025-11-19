import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isEmpty) {
            return const Center(
              child: Text('Panier vide'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.items[index];
                    return ListTile(
                      title: Text(item.product.title),
                      subtitle: Text('Qte: ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          viewModel.removeProduct(item.product.id);
                        },
                      ),
                    );
                  },
                ),
              ),
              Text('Total: ${viewModel.formattedTotal}'),
              ElevatedButton(
                onPressed: () {
                  context.push('/checkout');
                },
                child: const Text('Commander'),
              ),
            ],
          );
        },
      ),
    );
  }
}
