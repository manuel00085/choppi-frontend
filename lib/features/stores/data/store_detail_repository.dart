import 'store_detail_api.dart';
import 'store_detail_model.dart';

class StoreDetailRepository {
  final api = StoreDetailApi();

  Future<StoreDetailModel> fetchStore(int id, {bool inStock = false}) {
    return api.getStoreDetail(id, inStock: inStock);
  }
}
