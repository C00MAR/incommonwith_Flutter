import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);
    final user = authViewModel.currentUser;

    return Scaffold(
      // On enlève l'AppBar classique : tout est custom dans le body
      body: Stack(
        children: [
          /// Background image pleine page
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_bg.webp', // 🔁 remplace par ton image
              fit: BoxFit.cover,
            ),
          ),

          /// Contenu par-dessus l’image
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Ligne du haut : compteur + menu (en haut à droite)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _TopBox(
                        label: '${cartViewModel.itemsCount}',
                        onTap: () {
                          context.push('/cart');
                        },
                      ),
                      const SizedBox(width: 8),
                      _TopBox(
                        label: 'Menu',
                        onTap: () {
                          _showMenu(context, authViewModel, cartViewModel);
                        },
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// (Optionnel) petit texte de bienvenue en bas à gauche
                  if (user != null) ...[
                    Text(
                      'Bienvenue ${user.email}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black54,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  /// Bloc rouge : titre
                  const Text(
                    'In Common With',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Bloc bleu : sous-titre
                  const Text(
                    'A dialogue between light, material, and form.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Bouton vert : call to action
                  GestureDetector(
                    onTap: () {
                      context.push('/catalog');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Explore the Core Collection',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context, AuthViewModel authViewModel, CartViewModel cartViewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Catalogue'),
              onTap: () {
                Navigator.pop(context);
                context.push('/catalog');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Panier'),
              trailing: cartViewModel.itemsCount > 0
                  ? CircleAvatar(
                      radius: 12,
                      child: Text(
                        '${cartViewModel.itemsCount}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                context.push('/cart');
              },
            ),
            if (authViewModel.isAuthenticated) ...[
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Mes commandes'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/orders');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Se déconnecter', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  await cartViewModel.clearCart();
                  await authViewModel.signOut();
                },
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Petit widget pour les cases "0" et "Menu" en haut à droite
class _TopBox extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _TopBox({
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
          color: Colors.transparent,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
