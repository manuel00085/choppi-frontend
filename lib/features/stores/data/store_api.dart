import '../../../core/dio/dio_client.dart';
import 'store_model.dart';

class StoreApi {
  final dio = DioClient.instance;

  Future<List<StoreModel>> getStores({
    int page = 1,
    String? q,
  }) async {
    final res = await dio.get(
      "/stores",
      queryParameters: {
        "page": page,
        if (q != null && q.isNotEmpty) "q": q,
      },
    );

    final data = res.data["data"] as List;

    return data.map((e) => StoreModel.fromJson(e)).toList();
  }
}
