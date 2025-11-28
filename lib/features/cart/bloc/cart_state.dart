import 'package:equatable/equatable.dart';
import '../data/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  double get total => 
    items.fold(0, (sum, item) => sum + item.total);

  const CartState({required this.items});

  @override
  List<Object?> get props => [items];
}
