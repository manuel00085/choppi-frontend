import '../../../core/dio/dio_client.dart';
import 'store_detail_model.dart';

class StoreDetailApi {
  final dio = DioClient.instance;

  Future<StoreDetailModel> getStoreDetail(
    int storeId, {
    bool inStock = false,
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    final res = await dio.get(
      "/stores/$storeId/products",
      queryParameters: {
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'q': query,
        if (inStock) 'in_stock': 'true',
      },
    );
    return StoreDetailModel.fromJson(res.data);
  }
}
