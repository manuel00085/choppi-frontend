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
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) =>
          StoreDetailCubit(StoreDetailRepository())..loadDetail(widget.storeId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detalle de Tienda"),
        ),
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

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🏬 CARD DE INFORMACIÓN DE LA TIENDA
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                store.address,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

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
                                  context.read<StoreDetailCubit>().search("");
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
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    /// 🔘 SWITCH DE DISPONIBILIDAD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Solo disponibles",
                            style: TextStyle(fontSize: 16)),
                        Switch(
                          value: showAvailable,
                          activeColor: colors.primary,
                          onChanged: (value) {
                            setState(() => showAvailable = value);
                            context.read<StoreDetailCubit>().loadDetail(
                                  widget.storeId,
                                  inStock: value,
                                );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// TÍTULO DE PRODUCTOS
                    const Text(
                      "Productos",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    /// 🛍 LISTA DE PRODUCTOS
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: store.products.length,
                      itemBuilder: (_, i) {
                        final p = store.products[i];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundColor: colors.primary.withOpacity(0.2),
                              child: Icon(
                                Icons.shopping_bag,
                                color: colors.primary,
                              ),
                            ),
                            title: Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "Stock: ${p.stock}",
                              style:
                                  TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: Text(
                              "\$${p.price}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
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
