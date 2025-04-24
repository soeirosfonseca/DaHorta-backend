import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class FarmerProductsScreen extends StatefulWidget {
  const FarmerProductsScreen({super.key});

  @override
  State<FarmerProductsScreen> createState() => _FarmerProductsScreenState();
}

class _FarmerProductsScreenState extends State<FarmerProductsScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts =
        ApiService.fetchProducts(); // Apenas os do agricultor autenticado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Produtos')),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text('${product.quantity} und.'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/agricultor/novo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
