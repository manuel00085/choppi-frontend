import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/product_repository.dart';
import '../data/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repo;

  ProductCubit(this.repo) : super(ProductInitial());

  Future<void> load(int id) async {
    emit(ProductLoading());
    try {
      final product = await repo.fetchProduct(id);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
