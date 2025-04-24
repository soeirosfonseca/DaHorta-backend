// ignore_for_file: file_names
import 'package:flutter/material.dart';

class DeliveryItem {
  final DateTime date;
  final String basketType;
  final bool pickedUp;

  DeliveryItem({
    required this.date,
    required this.basketType,
    required this.pickedUp,
  });
}

class DeliveryHistoryScreen extends StatelessWidget {
  final List<DeliveryItem> deliveries;

  const DeliveryHistoryScreen({super.key, required this.deliveries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Entregas')),
      body:
          deliveries.isEmpty
              ? const Center(
                child: Text(
                  'Você ainda não retirou nenhuma cesta.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: deliveries.length,
                itemBuilder: (context, index) {
                  final delivery = deliveries[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        delivery.pickedUp
                            ? Icons.check_circle
                            : Icons.access_time,
                        color: delivery.pickedUp ? Colors.green : Colors.orange,
                      ),
                      title: Text(delivery.basketType),
                      subtitle: Text('Data: ${_formatDate(delivery.date)}'),
                      trailing: Text(
                        delivery.pickedUp ? 'Retirada' : 'Pendente',
                        style: TextStyle(
                          color:
                              delivery.pickedUp ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
