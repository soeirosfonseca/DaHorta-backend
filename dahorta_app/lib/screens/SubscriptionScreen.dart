import 'dart:convert';

import 'package:dahorta_app/models/subscription.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports, unused_import
import 'package:http/src/response.dart';
import '../services/api_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Subscription? _current;
  bool _loading = true;

  final plans = [
    {'title': 'Cesta Simples', 'price': 29, 'value': 'simples'},
    {'title': 'Cesta Premium', 'price': 49, 'value': 'premium'},
    {'title': 'Cesta Master', 'price': 69, 'value': 'master'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    final res = await ApiService.get('/subscription', auth: true);
    if (res.statusCode == 200) {
      setState(() {
        _current = Subscription.fromJson(jsonDecode(res.body)['subscription']);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _subscribeTo(String plan) async {
    final res = await ApiService.post('/subscribe', {'plan': plan}, auth: true);

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Assinatura atualizada!')));
      _loadSubscription();
    } else {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao assinar plano')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Assinatura')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_current != null) ...[
                      Text(
                        'Plano Atual: ${_current!.plan.toUpperCase()}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text('Status: ${_current!.status}'),
                      Text(
                        'Próxima cobrança: ${_current!.nextBillingDate.toLocal()}',
                      ),
                      const Divider(height: 32),
                    ],
                    const Text(
                      'Escolha um plano:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ...plans.map(
                      (p) => Card(
                        child: ListTile(
                          title: Text(p['title'] as String),
                          subtitle: Text('R\$ ${p['price']}/mês'),
                          trailing: ElevatedButton(
                            onPressed: () => _subscribeTo(p['value'] as String),
                            child: const Text('Assinar'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
