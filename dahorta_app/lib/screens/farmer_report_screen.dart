import 'package:flutter/material.dart';

class FarmerReportScreen extends StatelessWidget {
  const FarmerReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulação
    final totalVendas = 820.50;
    final pedidos = 27;

    return Scaffold(
  appBar: AppBar(title: const Text('Relatório de Vendas')),
  body: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumo do Mês', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        Text('Pedidos finalizados: $pedidos'),
        Text('Total arrecadado: R\$ ${totalVendas.toStringAsFixed(2)}'),
      ],
    ),
  ),
);

  }
}

