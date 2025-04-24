import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: implementation_imports
import 'package:http/src/response.dart';
// ignore: unused_import
import 'package:latlong2/latlong.dart';
import '../models/collection_point.dart';
import '../services/api_service.dart';

class CollectionPointsMapScreen extends StatefulWidget {
  const CollectionPointsMapScreen({super.key});

  @override
  State<CollectionPointsMapScreen> createState() =>
      _CollectionPointsMapScreenState();
}

class _CollectionPointsMapScreenState extends State<CollectionPointsMapScreen> {
  List<CollectionPoint> _points = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final res = await ApiService.get('/collection-points', auth: true);
    if (res.statusCode == 200) {
      setState(() {
        _points =
            (res.data as List).map((e) => CollectionPoint.fromJson(e)).toList();
      });
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pontos de Coleta')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                options: MapOptions(
                  // ignore: deprecated_member_use
                  center:
                      _points.isNotEmpty
                          ? LatLng(_points[0].latitude, _points[0].longitude)
                          : LatLng(-2.99, -47.35),
                  // ignore: deprecated_member_use
                  zoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers:
                        _points.map((p) {
                          return Marker(
                            width: 80,
                            height: 80,
                            point: LatLng(p.latitude, p.longitude),
                            child: GestureDetector(
                              onTap: () => _showInfoDialog(p),
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
              ),
    );
  }

  void _showInfoDialog(CollectionPoint point) {
    // ignore: no_leading_underscores_for_local_identifiers
    bool _setAsPreferred = false;

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(point.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(point.address),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _setAsPreferred,
                            onChanged:
                                (value) =>
                                    setState(() => _setAsPreferred = value!),
                          ),
                          const Expanded(
                            child: Text(
                              'Definir como meu ponto de coleta preferido',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                    if (_setAsPreferred)
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final res = await ApiService.post(
                              '/preferred-collection-point',
                              {'collection_point_id': point.id},
                              auth: true,
                            );

                            if (res.statusCode == 200) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ponto preferido atualizado!'),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao salvar ponto preferido'),
                              ),
                            );
                          }
                        },
                        child: const Text('Confirmar'),
                      ),
                  ],
                ),
          ),
    );
  }
}

extension on Response {
  get data => null;
}
