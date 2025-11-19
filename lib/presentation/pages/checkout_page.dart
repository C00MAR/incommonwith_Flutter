import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/checkout_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation'),
      ),
      body: Consumer3<CartViewModel, CheckoutViewModel, AuthViewModel>(
        builder: (context, cartViewModel, checkoutViewModel, authViewModel, _) {
          return Column(
            children: [
              Text('Total: ${cartViewModel.formattedTotal}'),
              if (checkoutViewModel.isLoading)
                const CircularProgressIndicator(),
              ElevatedButton(
                onPressed: checkoutViewModel.isLoading ? null : () async {
                  final order = await checkoutViewModel.processCheckout(
                    cartViewModel.items,
                    authViewModel.currentUser!.email!,
                  );
                  if (order != null) {
                    await cartViewModel.clearCart();
                    if (context.mounted) {
                      context.go('/orders');
                    }
                  }
                },
                child: const Text('Valider la commande'),
              ),
            ],
          );
        },
      ),
    );
  }
}
