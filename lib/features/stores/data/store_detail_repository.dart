import 'store_detail_api.dart';
import 'store_detail_model.dart';

class StoreDetailRepository {
  final api = StoreDetailApi();

  Future<StoreDetailModel> fetchStore(
    int id, {
    bool inStock = false,
    String? query,
    int page = 1,
    int limit = 10,
  }) {
    return api.getStoreDetail(
      id,
      inStock: inStock,
      query: query,
      page: page,
      limit: limit,
    );
  }
}
