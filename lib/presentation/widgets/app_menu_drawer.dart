import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/catalog_viewmodel.dart';

class AppMenuDrawer extends StatefulWidget {
  const AppMenuDrawer({super.key});

  @override
  State<AppMenuDrawer> createState() => _AppMenuDrawerState();
}

class _AppMenuDrawerState extends State<AppMenuDrawer> {
  bool _productExpanded = false;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);
    final catalogViewModel = Provider.of<CatalogViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF4A1D0F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, cartViewModel),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    _buildExpandableSection(
                      title: 'Product',
                      isExpanded: _productExpanded,
                      onTap: () {
                        setState(() {
                          _productExpanded = !_productExpanded;
                        });
                      },
                      children: [
                        _buildMenuItem('All Products', () {
                          catalogViewModel.filterByCategory('');
                          context.push('/catalog');
                          Navigator.pop(context);
                        }),
                        ...catalogViewModel.categories.map((category) {
                          return _buildMenuItem(category, () {
                            catalogViewModel.filterByCategory(category);
                            context.push('/catalog');
                            Navigator.pop(context);
                          });
                        }),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            _buildFooter(context, authViewModel),
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
            onTap: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: const Text(
              'In Common With',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Row(
            children: [
              _buildHeaderButton('${cartViewModel.itemsCount}', () {
                context.push('/cart');
                Navigator.pop(context);
              }),
              const SizedBox(width: 8),
              _buildHeaderButton('Close', () {
                Navigator.pop(context);
              }),
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
          border: Border.all(color: Colors.white, width: 1),
          color: Colors.transparent,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.remove : Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...children,
      ],
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AuthViewModel authViewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (authViewModel.isAuthenticated) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFooterItem('Cart', () {
                  context.push('/cart');
                  Navigator.pop(context);
                }),
                _buildFooterItem('Account', () {
                  context.push('/account');
                  Navigator.pop(context);
                }),
                _buildFooterItem('Order', () {
                  context.push('/orders');
                  Navigator.pop(context);
                }),
                _buildFooterItem('Logout', () async {
                  Navigator.pop(context);
                  await authViewModel.signOut();
                }),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFooterItem('Cart', () {
                  context.push('/cart');
                  Navigator.pop(context);
                }),
                _buildFooterItem('Login', () {
                  context.push('/login');
                  Navigator.pop(context);
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooterItem(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
