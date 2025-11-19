import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/catalog_page.dart';
import '../presentation/pages/product_detail_page.dart';
import '../presentation/pages/cart_page.dart';
import '../presentation/pages/checkout_page.dart';
import '../presentation/pages/orders_page.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import 'guards.dart';

GoRouter createRouter(AuthViewModel authViewModel) {
  return GoRouter(
    initialLocation: '/home',
    redirect: AuthGuard.redirect,
    refreshListenable: authViewModel,
    routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/catalog',
      builder: (context, state) => const CatalogPage(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailPage(productId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page non trouvee: ${state.uri}'),
    ),
  ),
  );
}
