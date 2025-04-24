import 'package:flutter/material.dart';

class PickupNotificationScreen extends StatelessWidget {
  final String? collectionPointName;
  final String? collectionPointAddress;
  final DateTime? nextPickupDate;

  const PickupNotificationScreen({
    super.key,
    required this.collectionPointName,
    required this.collectionPointAddress,
    required this.nextPickupDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retirada da Cesta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            collectionPointName == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Você ainda não escolheu um ponto de coleta preferido.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/select-collection-point',
                        );
                      },
                      child: const Text('Escolher agora'),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seu ponto de coleta preferido:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      title: Text(collectionPointName!),
                      subtitle: Text(collectionPointAddress!),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text(
                      'Próxima Retirada:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      nextPickupDate != null
                          ? 'Sua cesta estará disponível em ${_formatDate(nextPickupDate!)}'
                          : 'Informação ainda não disponível.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} às ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
