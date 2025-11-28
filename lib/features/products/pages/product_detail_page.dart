import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_cubit.dart';
import '../data/product_repository.dart';
import '../../stores/data/store_product_model.dart';
import '../../../core/app_notifier.dart';
import '../../cart/bloc/cart_cubit.dart';
import '../../cart/data/cart_item.dart';

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
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => ProductCubit(ProductRepository())..load(productId),
      child: Scaffold(
        appBar: AppBar(title: Text(storeProduct.name)),

        /// 📌 BOTÓN FIJO ABAJO
                  bottomNavigationBar: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: BlocBuilder<ProductCubit, ProductState>(
                        builder: (_, state) {
                          if (state is ProductLoaded) {
                            final p = state.product;

                            final imageUrl = (p.images.isNotEmpty)
                                ? p.images.first
                                : "https://placehold.co/600x400/png?text=${p.name}";

                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  /// 🛒 Agregar al carrito real
                                  context.read<CartCubit>().addItem(
                                        CartItem(
                                          productId: p.id,
                                          name: p.name,
                                          price: storeProduct.price,
                                          quantity: 1,
                                          image: imageUrl,
                                        ),
                                      );

                                  /// 🎉 Notificación
                                  AppNotifier.showSuccess("Producto agregado al carrito");
                                },
                                child: const Text(
                                  "Agregar al carrito",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ),


        /// CONTENIDO
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

              /// Imagen final (real o generada)
              final imageUrl = (p.images.isNotEmpty)
                  ? p.images.first
                  : "https://placehold.co/600x400/png?text=${p.name}";

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 📸 IMAGEN PRINCIPAL
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 📝 TÍTULO
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (p.category != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Categoría: ${p.category}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    /// 💲 CARD DE PRECIO Y STOCK
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Precio
                          Text(
                            "\$${storeProduct.price}",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),

                          /// Stock
                          Row(
                            children: [
                              const Icon(Icons.inventory_2,
                                  color: Colors.grey, size: 22),
                              const SizedBox(width: 6),
                              Text(
                                "Stock: ${storeProduct.stock}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// 📄 DESCRIPCIÓN
                    const Text(
                      "Descripción del producto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      p.description ?? "Sin descripción disponible.",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),

                    const SizedBox(height: 30),
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
