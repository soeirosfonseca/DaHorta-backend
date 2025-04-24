import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/api_service.dart';

class FarmerProductCreateScreen extends StatefulWidget {
  const FarmerProductCreateScreen({super.key});

  @override
  State<FarmerProductCreateScreen> createState() => _FarmerProductCreateScreenState();
}

class _FarmerProductCreateScreenState extends State<FarmerProductCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final res = await ApiService.post('/products', {
          'name': _nameCtrl.text,
          'description': _descCtrl.text,
          'quantity': int.parse(_qtyCtrl.text),
        });

        if (res.statusCode == 201) {
          Fluttertoast.showToast(msg: 'Produto cadastrado!');
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(msg: 'Erro ao salvar: ${res.body}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Erro: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
              validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextFormField(
              controller: _qtyCtrl,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProduct, child: const Text('Salvar')),
          ]),
        ),
      ),
    );
  }
}
