// ignore_for_file: file_names, use_build_context_synchronously, unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:http/src/response.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductSelectionScreen extends StatefulWidget {
  final int maxSelection;

  const ProductSelectionScreen({super.key, required this.maxSelection});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  List<Product> _products = [];
  final List<int> _selectedIds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final res = await ApiService.get('/products', auth: true);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      setState(() {
        _products = data.map((e) => Product.fromJson(e)).toList();
      });
    }
    setState(() => _loading = false);
  }

  void _toggleSelection(int productId) {
    setState(() {
      if (_selectedIds.contains(productId)) {
        _selectedIds.remove(productId);
      } else {
        if (_selectedIds.length < widget.maxSelection) {
          _selectedIds.add(productId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seus produtos')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Você pode escolher até ${widget.maxSelection} itens.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                          _products.map((product) {
                            final selected = _selectedIds.contains(product.id);
                            return ListTile(
                              title: Text(product.name),
                              trailing:
                                  selected
                                      ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                      : null,
                              onTap: () => _toggleSelection(product.id),
                            );
                          }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        _selectedIds.length == widget.maxSelection
                            ? () async {
                              try {
                                final res = await ApiService.post(
                                  '/selected-products',
                                  {'product_ids': _selectedIds},
                                  auth: true,
                                );

                                if (res.statusCode == 200) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Produtos selecionados com sucesso!',
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Erro ao enviar seleção'),
                                  ),
                                );
                              }
                            }
                            : null,
                    child: const Text('Confirmar seleção'),
                  ),
                ],
              ),
    );
  }
}
