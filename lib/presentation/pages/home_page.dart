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
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
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
                        label: '0',
                        onTap: () {
                          // TODO: action pour le "0" (ex : panier)
                        },
                      ),
                      const SizedBox(width: 8),
                      _TopBox(
                        label: 'Menu',
                        onTap: () {
                          // TODO: ouvrir un menu latéral ou autre
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
                  const SizedBox(height: 16),

                  /// Bouton logout discret (optionnel, pour garder la feature)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () async {
                        await cartViewModel.clearCart();
                        await authViewModel.signOut();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Se déconnecter'),
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
