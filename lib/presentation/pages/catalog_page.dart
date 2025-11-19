import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/catalog_viewmodel.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
      ),
      body: Column(
        children: [
          Consumer<CatalogViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Rechercher',
                    ),
                    onChanged: (value) {
                      viewModel.searchProducts(value);
                    },
                  ),
                  DropdownButton<String>(
                    value: viewModel.selectedCategory.isEmpty ? null : viewModel.selectedCategory,
                    hint: const Text('Toutes les categories'),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('Toutes les categories'),
                      ),
                      ...viewModel.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      viewModel.filterByCategory(value ?? '');
                    },
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: Consumer<CatalogViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (viewModel.hasError) {
                  return Center(
                    child: Text(viewModel.errorMessage),
                  );
                }

                return ListView.builder(
                  itemCount: viewModel.products.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.products[index];
                    return ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.formattedPrice),
                      onTap: () {
                        context.push('/product/${product.id}');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
