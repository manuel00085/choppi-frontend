import '../../../core/dio/dio_client.dart';

class StoreApi {
  final dio = DioClient.instance;

  Future<Map<String, dynamic>> getStores({
    int page = 1,
    String? q,
  }) async {
    final res = await dio.get(
      "/stores",
      queryParameters: {
        "page": page,
        "limit": 5,
        if (q != null && q.isNotEmpty) "q": q,
      },
    );

    return res.data;  // 👈 DEVUELVE EL JSON COMPLETO
  }
}
