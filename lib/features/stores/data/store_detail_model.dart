import 'store_product_model.dart';

class StoreDetailModel {
  final int id;
  final String name;
  final String address;
  final List<StoreProductModel> products;

  StoreDetailModel({
    required this.id,
    required this.name,
    required this.address,
    required this.products,
  });

  factory StoreDetailModel.fromJson(Map<String, dynamic> json) {
    return StoreDetailModel(
      id: json['store']['id'],
      name: json['store']['name'],
      address: json['store']['address'],
      products: (json['products'] as List)
          .map((p) => StoreProductModel.fromJson(p))
          .toList(),
    );
  }
}
