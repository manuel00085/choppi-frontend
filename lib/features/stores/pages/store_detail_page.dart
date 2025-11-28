import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/store_detail_cubit.dart';
import '../data/store_detail_repository.dart';
import '../../products/pages/product_detail_page.dart';

class StoreDetailPage extends StatefulWidget {
  final int storeId;

  const StoreDetailPage({super.key, required this.storeId});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  final searchCtrl = TextEditingController();
   bool showAvailable = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StoreDetailCubit(StoreDetailRepository())..loadDetail(widget.storeId),
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

                    /// NOMBRE DE LA TIENDA
                    Text(store.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(store.address,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),

                    /// 🔍 BUSCADOR
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        labelText: "Buscar producto",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchCtrl.clear();
                                  context
                                      .read<StoreDetailCubit>()
                                      .search("");
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<StoreDetailCubit>().search(value);
                        setState(() {}); // para refrescar el botón de limpiar
                      },
                    ),
                    const SizedBox(height: 20),
                                          Row(
                        children: [
                          const Text("Solo disponibles"),
                          Switch(
                            value: showAvailable,
                            onChanged: (value) {
                              setState(() => showAvailable = value);
                              context.read<StoreDetailCubit>().loadDetail(widget.storeId, inStock: value);
                            },
                          ),
                        ],
                      ),


                    const Text("Productos:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    /// LISTA DE PRODUCTOS
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailPage(
                                      productId: p.productId,
                                      storeProduct: p,
                                    ),
                                  ),
                                );
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
