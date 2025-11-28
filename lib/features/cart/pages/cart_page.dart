import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import '../../../core/app_notifier.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Carrito")),

      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text("Tu carrito está vacío"),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (_, i) {
                    final item = state.items[i];

                    return Card(
                      child: ListTile(
                        leading: item.image != null
                            ? Image.network(item.image!)
                            : const Icon(Icons.shopping_bag),
                        title: Text(item.name),
                        subtitle: Text("Cantidad: ${item.quantity}"),
                        trailing: Text("\$${item.total.toStringAsFixed(2)}"),
                      ),
                    );
                  }
                ),
              ),

              // TOTAL
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Total: \$${state.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        AppNotifier.showSuccess("Compra realizada (demo)");
                      },
                      child: const Text("Finalizar compra"),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
