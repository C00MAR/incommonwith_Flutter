import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/app_menu_drawer.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);
    final user = authViewModel.currentUser;

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

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Overview',
                        style: TextStyle(
                          color: Color(0xFF4A1D0F),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Container(
                        height: 1,
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 32),

                      if (user != null) ...[
                        _buildInfoSection(
                          title: 'Name',
                          content: user.displayName ?? 'Name Placeholder',
                        ),
                        const SizedBox(height: 32),

                        _buildInfoSection(
                          title: 'Contact Info',
                          content: user.email ?? 'email@placeholder',
                        ),
                        const SizedBox(height: 48),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => context.push('/orders'),
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
                              'Orders',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () async {
                              await cartViewModel.clearCart();
                              await authViewModel.signOut();
                              if (context.mounted) {
                                context.go('/home');
                              }
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
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Vous devez être connecté pour accéder à votre compte.',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => context.push('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A1D0F),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Se connecter',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
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

  Widget _buildInfoSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFF4A1D0F),
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
