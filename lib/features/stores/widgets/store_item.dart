import 'package:flutter/material.dart';
import '../data/store_model.dart';

class StoreItem extends StatelessWidget {
  final StoreModel store;

  const StoreItem({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(store.name),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, "/store/${store.id}");
        },
      ),
    );
  }
}
