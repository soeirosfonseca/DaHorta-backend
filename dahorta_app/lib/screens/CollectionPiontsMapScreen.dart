// lib/screens/collection_points_map_screen.dart

import 'package:flutter/material.dart';

class CollectionPointsMapScreen extends StatelessWidget {
  const CollectionPointsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pontos de Coleta')),
      body: const Center(
        child: Text('Aqui vai o mapa com os pontos de coleta'),
      ),
    );
  }
}
