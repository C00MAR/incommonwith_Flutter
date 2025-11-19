import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:incommonwith_flutter/data/models/product.dart';

void main() {
  testWidgets('ProductCard affiche le titre et le prix', (tester) async {
    final product = Product(
      id: '1',
      title: 'Test Product',
      price: 99.99,
      thumbnail: 'https://example.com/image.jpg',
      images: ['https://example.com/image.jpg'],
      description: 'Test description',
      category: 'test',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListTile(
            title: Text(product.title),
            subtitle: Text(product.formattedPrice),
          ),
        ),
      ),
    );

    expect(find.text(product.title), findsOneWidget);
    expect(find.text(product.formattedPrice), findsOneWidget);
  });
}
