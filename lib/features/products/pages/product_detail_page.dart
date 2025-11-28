import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_cubit.dart';
import '../data/product_repository.dart';
import '../../stores/data/store_product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  final StoreProductModel storeProduct;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.storeProduct,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(ProductRepository())..load(productId),
      child: Scaffold(
        appBar: AppBar(title: Text(storeProduct.name)),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (_, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            if (state is ProductLoaded) {
              final p = state.product;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (p.images.isNotEmpty)
                      Image.network(p.images.first, height: 250),

                    const SizedBox(height: 20),

                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),

                    if (p.category != null)
                      Text("Categoría: ${p.category}",
                          style: const TextStyle(color: Colors.grey)),

                    const SizedBox(height: 20),

                    // precio y stock de la tienda
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${storeProduct.price}",
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Text(
                          "Stock: ${storeProduct.stock}",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (p.description != null)
                      Text(p.description!,
                          style: const TextStyle(fontSize: 16)),
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
