class Product {
  final int id;
  final String name;
  final String description;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
}
