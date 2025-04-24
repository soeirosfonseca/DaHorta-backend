// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _quantity = 1;
  String _unit = 'kg';

  final _units = ['kg', 'maços', 'litros', 'unidades'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Produto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (val) => val!.isEmpty ? 'Informe o nome' : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                initialValue: '1',
                validator:
                    (val) =>
                        int.tryParse(val!) == null ? 'Número inválido' : null,
                onSaved: (val) => _quantity = int.parse(val!),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Unidade'),
                value: _unit,
                onChanged: (val) => setState(() => _unit = val!),
                items:
                    _units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              final res = await ApiService.post('/products', {
                'name': _name,
                'quantity': _quantity,
                'unit': _unit,
              }, auth: true);

              if (res.statusCode == 200 || res.statusCode == 201) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context, true); // sinaliza sucesso
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao salvar produto')),
                );
              }
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
