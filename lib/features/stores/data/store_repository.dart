import 'store_api.dart';
import 'store_paginated_model.dart';

class StoreRepository {
  final api = StoreApi();

  Future<PaginatedStores> fetchStores({
    int page = 1,
    String? search,
  }) async {
    final res = await api.getStores(page: page, q: search);
    return PaginatedStores.fromJson(res);
  }
}

