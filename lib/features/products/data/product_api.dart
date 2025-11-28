import '../../../core/dio/dio_client.dart';
import 'product_model.dart';

class ProductApi {
  final dio = DioClient.instance;

  Future<ProductModel> getProduct(int productId) async {
    final res = await dio.get("/products/$productId");
    return ProductModel.fromJson(res.data);
  }
}
