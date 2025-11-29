import 'store_product_model.dart';

class StoreDetailModel {
  final int id;
  final String name;
  final String address;
  final List<StoreProductModel> products;
  final int total;
  final int page;
  final int limit;

  StoreDetailModel({
    required this.id,
    required this.name,
    required this.address,
    required this.products,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory StoreDetailModel.fromJson(Map<String, dynamic> json) {
    final store = json['store'] ?? {};
    final meta = json['meta'] ?? json;
    final productsJson = (json['products'] as List?) ?? [];

    return StoreDetailModel(
      id: store['id'],
      name: store['name'],
      address: store['address'],
      products:
          productsJson.map((p) => StoreProductModel.fromJson(p)).toList(),
      total: meta['total'] ?? productsJson.length,
      page: meta['page'] ?? 1,
      limit: meta['limit'] ?? productsJson.length,
    );
  }
}
