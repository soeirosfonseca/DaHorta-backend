import 'package:dahorta_app/screens/ProductSelectionScreen.dart';
import 'package:dahorta_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import '../providers/auth_provider.dart';
import '../providers/UserProvider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = context.watch<UserProvider>().name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DaHorta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body:
          auth.user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${auth.user!['name']} 👋',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Tipo de conta: ${auth.user!['role']}'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/produtos');
                      },
                      child: const Text('Ver Produtos Disponíveis'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/assinatura');
                      },
                      child: const Text('Assinar uma cesta'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/pontos');
                      },
                      child: const Text('Ver Pontos de Coleta'),
                    ),
                    if (user?.isFarmer == true)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/agricultor');
                        },
                        child: const Text('Área do Agricultor'),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        final plano = context.read<UserProvider>().user!.role;
                        final limite = switch (plano) {
                          'Simples' => 5,
                          'Premium' => 8,
                          'Master' => 12,
                          _ => 5,
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductSelectionScreen(
                                  maxSelection: limite,
                                ),
                          ),
                        );
                      },
                      child: const Text('Montar minha cesta'),
                    ),
                  ],
                ),
              ),
    );
  }
}
