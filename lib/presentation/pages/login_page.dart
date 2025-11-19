import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          Consumer<AuthViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                children: [
                  if (viewModel.hasError)
                    Text(viewModel.errorMessage),
                  if (viewModel.isLoading)
                    const CircularProgressIndicator(),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () {
                      viewModel.signInWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text('Se connecter'),
                  ),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () {
                      viewModel.registerWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text('S\'inscrire'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
