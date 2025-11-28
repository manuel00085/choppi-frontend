class StoreProductModel {
  final int id;
  final int productId;
  final String name;
  final double price;
  final int stock;

  StoreProductModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    return StoreProductModel(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'],
    );
  }
}
