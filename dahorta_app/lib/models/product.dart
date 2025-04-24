class Product {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final String unit;
  final bool available;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.available,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      unit: json['unit'],
      available: json['available'],
    );
  }
}
