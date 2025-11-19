import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';

class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final isAuthenticated = authViewModel.isAuthenticated;

    final protectedRoutes = ['/cart', '/checkout', '/orders'];
    final isGoingToProtected =
        protectedRoutes.any((route) => state.fullPath?.startsWith(route) ?? false);

    if (!isAuthenticated && isGoingToProtected) {
      return '/login';
    }

    if (isAuthenticated && state.fullPath == '/login') {
      return '/home';
    }

    return null;
  }
}
