import 'package:bloc/bloc.dart';
import 'cart_state.dart';
import '../data/cart_item.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(items: []));

  void addItem(CartItem item) {
    final items = [...state.items];

    final index = items.indexWhere((i) => i.productId == item.productId);

    if (index >= 0) {
      items[index].quantity += item.quantity;
    } else {
      items.add(item);
    }

    emit(CartState(items: items));
  }

  void removeItem(int productId) {
    final items = state.items.where((i) => i.productId != productId).toList();
    emit(CartState(items: items));
  }

  void updateQuantity(int productId, int qty) {
    final items = [...state.items];
    final index = items.indexWhere((i) => i.productId == productId);

    if (index >= 0) {
      items[index].quantity = qty;
    }

    emit(CartState(items: items));
  }

  void clear() {
    emit(CartState(items: []));
  }
}
