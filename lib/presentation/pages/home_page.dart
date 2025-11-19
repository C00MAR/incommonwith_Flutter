import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authViewModel.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Bienvenue ${user?.email ?? ''}'),
          ElevatedButton(
            onPressed: () {
              context.push('/catalog');
            },
            child: const Text('Catalogue'),
          ),
        ],
      ),
    );
  }
}
