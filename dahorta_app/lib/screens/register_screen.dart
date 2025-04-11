import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'consumer';
  String? error;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            DropdownButtonFormField<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'consumer', child: Text('Consumidor')),
                DropdownMenuItem(value: 'farmer', child: Text('Agricultor')),
              ],
              onChanged: (value) => setState(() => role = value!),
              decoration: const InputDecoration(labelText: 'Tipo de usuário'),
            ),
            const SizedBox(height: 20),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() {
                        loading = true;
                        error = null;
                      });
                      final success = await auth.register(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                        role,
                      );
                      setState(() => loading = false);
                      if (!success) {
                        setState(() => error = 'Erro ao registrar usuário');
                      } else {
                        Navigator.pop(context);
                      }
                    },
              child: loading ? const CircularProgressIndicator() : const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
