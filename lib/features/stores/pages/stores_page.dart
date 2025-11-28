import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stores_cubit.dart';
import '../widgets/store_item.dart';
import '../../auth/pages/auth_gate.dart';
import '../../../core/storage/secure_storage.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stores"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SecureStorage.clearToken();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AuthGate()),
                (_) => false,
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                labelText: "Buscar tienda",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context
                        .read<StoresCubit>()
                        .loadStores(search: searchCtrl.text.trim());
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<StoresCubit, StoresState>(
                builder: (context, state) {
                  if (state is StoresLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is StoresError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }
                  if (state is StoresLoaded) {
                    if (state.stores.isEmpty) {
                      return const Center(child: Text("No hay tiendas"));
                    }
                    return ListView.builder(
                      itemCount: state.stores.length,
                      itemBuilder: (_, i) => StoreItem(store: state.stores[i]),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
