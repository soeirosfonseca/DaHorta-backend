import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/collection_point.dart';
import '../services/api_service.dart';
import 'package:latlong2/latlong.dart';

class CollectionPointsScreen extends StatefulWidget {
  const CollectionPointsScreen({super.key});

  @override
  State<CollectionPointsScreen> createState() => _CollectionPointsScreenState();
}

class _CollectionPointsScreenState extends State<CollectionPointsScreen> {
  late Future<List<CollectionPoint>> _futurePoints;

  @override
  void initState() {
    super.initState();
    _futurePoints = ApiService.fetchCollectionPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pontos de Coleta')),
      body: FutureBuilder<List<CollectionPoint>>(
        future: _futurePoints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final points = snapshot.data!;
          if (points.isEmpty) {
            return const Center(
              child: Text('Nenhum ponto de coleta cadastrado.'),
            );
          }

          return FlutterMap(
            options: MapOptions(center: points.first.position, zoom: 13.0),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.dahorta.app',
              ),
              MarkerLayer(
                markers:
                    points.map((p) {
                      return Marker(
                        width: 80,
                        height: 80,
                        point: p.position,
                        child: Tooltip(
                          message: p.name,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
