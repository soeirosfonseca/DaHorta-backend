// ignore_for_file: unused_import

import 'package:dahorta_app/services/auth_service.dart' show AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isRegisterMode = false;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success;

    if (_isRegisterMode) {
      success = await authProvider.register(
        'Usuário', // depois adicionamos campo nome se quiser
        _emailCtrl.text.trim(),
        _passwordCtrl.text.trim(),
        'cliente',
      );
    } else {
      success = await authProvider.login(
        _emailCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Erro ao ${_isRegisterMode ? "registrar" : "entrar"}.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegisterMode ? 'Registrar' : 'Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isRegisterMode ? 'Registrar' : 'Entrar'),
              ),
            TextButton(
              onPressed: () {
                setState(() => _isRegisterMode = !_isRegisterMode);
              },
              child: Text(
                _isRegisterMode
                    ? 'Já tem conta? Entrar'
                    : 'Não tem conta? Registrar',
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
