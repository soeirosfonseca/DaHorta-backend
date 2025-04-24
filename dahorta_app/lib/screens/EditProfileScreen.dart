// ignore_for_file: file_names, library_prefixes, unused_local_variable
import 'dart:convert';
import 'package:dahorta_app/models/user.dart';
import 'package:dahorta_app/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;

  const EditProfileScreen({super.key, required this.initialName});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final TextEditingController _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final data = {'name': _nameController.text};

    if (_passwordController.text.isNotEmpty) {
      data['password'] = _passwordController.text;
      data['password_confirmation'] = _confirmController.text;
    }

    final res = await ApiService.put('/user', data, auth: true);

    setState(() => _loading = false);

    if (res.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true); // Retorna sucesso
    } else {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao atualizar perfil')));
    }
  }

  Future<void> _loadProfile() async {
    final response = await ApiService.get('/user', auth: true);

    if (response.statusCode == 200) {
      // Atualiza os dados do perfil
      final Map<String, dynamic> json = jsonDecode(response.body);
      final user = User.fromJson(json);

      setState(() {});
    } else {
      throw Exception('Erro ao carregar perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Nova senha'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
                obscureText: true,
                validator: (val) {
                  if (_passwordController.text.isNotEmpty &&
                      val != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child:
                    _loading
                        ? const CircularProgressIndicator()
                        : const Text('Salvar alterações'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final user = context.read<UserProvider>().user!;
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(initialName: user.name),
                    ),
                  );
                  if (updated == true) {
                    _loadProfile(); // ou loadProfile(), se tiver esse método
                  }
                },
                child: const Text('Editar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
