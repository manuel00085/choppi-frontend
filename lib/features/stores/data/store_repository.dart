import 'store_api.dart';
import 'store_model.dart';

class StoreRepository {
  final api = StoreApi();

  Future<List<StoreModel>> fetchStores({
    int page = 1,
    String? search,
  }) {
    return api.getStores(page: page, q: search);
  }
}
