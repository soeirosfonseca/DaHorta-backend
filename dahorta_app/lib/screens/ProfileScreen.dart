// ignore_for_file: file_names
import 'dart:convert';
import 'package:dahorta_app/screens/EditProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import '../models/user.dart';
import '../models/subscription.dart';
import '../services/api_service.dart';
import '../providers/UserProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Subscription? _subscription;
  late bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    try {
      final response = await ApiService.get('/minha-assinatura', auth: true);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        setState(() {
          _subscription = Subscription.fromJson(json['subscription']);
          _loading = false;
        });
      } else {
        throw Exception('Erro ao carregar assinatura');
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user!;

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome: ${user.name}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    if (_subscription != null) ...[
                      const Text(
                        'Assinatura atual:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Plano: ${_subscription!.planName}'),
                      Text(
                        'Status: ${_subscription!.active ? "Ativa" : "Inativa"}',
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      EditProfileScreen(initialName: user.name),
                            ),
                          );
                          if (updated == true) loadSubscription();
                        },
                        child: const Text('Editar Perfil'),
                      ),
                    ] else
                      const Text('Você não possui uma assinatura ativa.'),
                  ],
                ),
      ),
    );
  }
}
