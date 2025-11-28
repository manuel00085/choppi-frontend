class CartItem {
  final int productId;
  final String name;
  final double price;
  int quantity;
  final String? image;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  double get total => price * quantity;
}
