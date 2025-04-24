// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/AddProductDialog.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = ApiService.fetchProducts();
    });
  }

  void _openAddProductDialog() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const AddProductDialog(),
    );

    if (result == true) {
      _loadProducts(); // Recarrega os produtos apenas se algo foi adicionado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos Disponíveis')),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(
              child: Text('Nenhum produto disponível no momento.'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text('${product.quantity} disponíveis'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
