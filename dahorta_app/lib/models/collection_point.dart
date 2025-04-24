import 'package:latlong2/latlong.dart';

class CollectionPoint {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String openingHours;

  CollectionPoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.openingHours,
  });

  factory CollectionPoint.fromJson(Map<String, dynamic> json) {
    return CollectionPoint(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toDouble() ?? 0.0,
      longitude: json['longitude'].toDouble() ?? 0.0,
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      openingHours: json['opening_hours'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'opening_hours': openingHours,
    };
  }

  LatLng get position => LatLng(latitude, longitude);
}
