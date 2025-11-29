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
  final scrollCtrl = ScrollController();
  bool showAvailable = false;

  @override
  void initState() {
    super.initState();
    scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollCtrl.removeListener(_onScroll);
    scrollCtrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!scrollCtrl.hasClients) return;

    final position = scrollCtrl.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<StoreDetailCubit>().loadMore();
    }
  }

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
              final store = state.store;

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<StoreDetailCubit>().refresh(),
                child: CustomScrollView(
                  controller: scrollCtrl,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
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
                                      const Icon(Icons.location_on,
                                          color: Colors.grey),
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
                                  const SizedBox(height: 8),
                                  Text(
                                    "Mostrando ${state.products.length} de ${store.total} productos",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  )
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
                                setState(() {});
                                scrollCtrl.jumpTo(0);
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
                                    scrollCtrl.jumpTo(0);
                                    context.read<StoreDetailCubit>().loadDetail(
                                          widget.storeId,
                                          inStock: value,
                                          query: searchCtrl.text,
                                        );
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// TÍTULO DE PRODUCTOS
                            const Text(
                              "Productos",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (state.products.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            searchCtrl.text.isNotEmpty
                                ? "No se encontraron productos para esa búsqueda."
                                : "Esta tienda aún no tiene productos para mostrar.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            if (i >= state.products.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: state.isLoadingMore
                                      ? const CircularProgressIndicator()
                                      : const SizedBox.shrink(),
                                ),
                              );
                            }

                            final p = state.products[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                        colors.primary.withOpacity(0.2),
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
                              ),
                            );
                          },
                          childCount:
                              state.products.length + (state.hasMore ? 1 : 0),
                        ),
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
