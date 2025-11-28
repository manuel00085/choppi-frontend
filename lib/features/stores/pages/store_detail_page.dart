import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/store_detail_cubit.dart';
import '../data/store_detail_repository.dart';
import '../data/store_detail_model.dart';

class StoreDetailPage extends StatelessWidget {
  final int storeId;

  const StoreDetailPage({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreDetailCubit(StoreDetailRepository())..loadDetail(storeId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Detalle de Tienda")),
        body: BlocBuilder<StoreDetailCubit, StoreDetailState>(
          builder: (context, state) {
            if (state is StoreDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StoreDetailError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            if (state is StoreDetailLoaded) {
              final store = state.data;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(store.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(store.address, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),

                    const Text("Productos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: store.products.length,
                        itemBuilder: (_, i) {
                          final p = store.products[i];
                          return Card(
                            child: ListTile(
                              title: Text(p.name),
                              subtitle: Text("Stock: ${p.stock}"),
                              trailing: Text("\$${p.price}"),
                              onTap: () {
                                // Ir al detalle del producto
                              },
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
