import '../../../core/dio/dio_client.dart';
import 'store_detail_model.dart';

class StoreDetailApi {
  final dio = DioClient.instance;

  Future<StoreDetailModel> getStoreDetail(int storeId, {bool inStock = false}) async {
    final res = await dio.get("/stores/$storeId/products", queryParameters:{
      if (inStock) 'in_stock': 'true',
    });
    return StoreDetailModel.fromJson(res.data);
  }
}
