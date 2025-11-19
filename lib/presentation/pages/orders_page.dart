import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/checkout_viewmodel.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes commandes'),
      ),
      body: Consumer<CheckoutViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.orders.isEmpty) {
            return const Center(
              child: Text('Aucune commande'),
            );
          }

          return ListView.builder(
            itemCount: viewModel.orders.length,
            itemBuilder: (context, index) {
              final order = viewModel.orders[index];
              return ListTile(
                title: Text('Commande ${order.id}'),
                subtitle: Text('${order.formattedDate} - ${order.formattedTotal}'),
                trailing: Text(order.statusDisplay),
              );
            },
          );
        },
      ),
    );
  }
}
