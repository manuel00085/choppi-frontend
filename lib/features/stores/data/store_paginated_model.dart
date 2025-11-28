import 'store_model.dart';

class PaginatedStores {
  final List<StoreModel> data;
  final int total;
  final int page;
  final int limit;

  PaginatedStores({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedStores.fromJson(Map<String, dynamic> json) {
    return PaginatedStores(
      data: (json["data"] as List)
          .map((e) => StoreModel.fromJson(e))
          .toList(),
      total: json["total"],
      page: json["page"],
      limit: json["limit"],
    );
  }
}
