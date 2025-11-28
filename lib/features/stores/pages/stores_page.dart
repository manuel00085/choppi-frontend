import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_notifier.dart';
import '../bloc/stores_cubit.dart';
import 'store_detail_page.dart';
import '../../../core/storage/secure_storage.dart';
import '../../auth/pages/auth_gate.dart';
class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<StoresCubit>().loadStores();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tiendas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
          onPressed: () async {
            final confirm = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Cerrar sesión"),
                  content: const Text("¿Seguro que deseas cerrar tu sesión?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancelar"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text("Salir"),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              await SecureStorage.clearToken();
              AppNotifier.showSuccess("Sesión cerrada correctamente");

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AuthGate()),
                (_) => false,
              );
            }
          },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 Buscador
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                labelText: "Buscar tienda",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchCtrl.clear();
                          context.read<StoresCubit>().loadStores();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (text) {
                context.read<StoresCubit>().loadStores(search: text.trim());
                setState(() {});
              },
            ),

            const SizedBox(height: 20),

            /// 📌 Lista de tiendas
            Expanded(
                  child:NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo is ScrollEndNotification) {
                      final atBottom = scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 50;

                      if (atBottom) {
                        context.read<StoresCubit>().loadMore();
                      }
                    }
                    return false;
                  },
                child: BlocBuilder<StoresCubit, StoresState>(
                  builder: (context, state) {
                    if (state is StoresLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is StoresError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }

                    if (state is StoresLoaded) {
                      final stores = state.stores;

                      if (stores.isEmpty) {
                        return const Center(child: Text("No se encontraron tiendas"));
                      }

                        return ListView.builder(
                          itemCount: stores.length + (context.read<StoresCubit>().hasMore ? 1 : 0),
                          itemBuilder: (_, i) {
                            final cubit = context.read<StoresCubit>();

                            // Loader inferior únicamente si hay más páginas
                            if (i == stores.length) {
                              if (cubit.hasMore) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              } else {
                                return const SizedBox.shrink(); // Oculto cuando no hay más
                              }
                            }

                            // === EL ITEM DE TIENDA ===
                            final s = stores[i];
                            final imageUrl = "https://placehold.co/600x400/png?text=${s.name}";

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoreDetailPage(storeId: s.id),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: colors.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            s.address ?? "Dirección no disponible",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
