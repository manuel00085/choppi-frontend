import 'product_api.dart';
import 'product_model.dart';

class ProductRepository {
  final api = ProductApi();

  Future<ProductModel> fetchProduct(int id) {
    return api.getProduct(id);
  }
}
