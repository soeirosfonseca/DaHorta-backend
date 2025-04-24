// ignore_for_file: file_names, unused_import
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:http/src/response.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../screens/points_screen.dart';
import '../widgets/AddProductDialog.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final res = await ApiService.get('/products', auth: true);
    if (res.statusCode == 200) {
      setState(() {
        _products = (res.body as List).map((e) => Product.fromJson(e)).toList();
        _loading = false;
      });
    }
  }

  void _openAddProductDialog() {
    showDialog(
      context: context,
      builder: (_) => const AddProductDialog(),
    ).then((_) => _loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel do Agricultor')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (_, i) {
                  final p = _products[i];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.quantity} ${p.unit}'),
                    leading: const Icon(Icons.spa, color: Colors.green),
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
