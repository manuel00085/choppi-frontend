import 'store_detail_api.dart';
import 'store_detail_model.dart';

class StoreDetailRepository {
  final api = StoreDetailApi();

  Future<StoreDetailModel> fetchStore(int storeId) {
    return api.getStoreDetail(storeId);
  }
}
