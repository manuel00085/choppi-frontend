import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'store_detail_repository.dart';
import 'store_detail_model.dart';
import 'store_product_model.dart';

part 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final StoreDetailRepository repo;
  List<StoreProductModel> _allProducts = [];

  StoreDetailCubit(this.repo) : super(StoreDetailInitial());

  Future<void> loadDetail(int storeId, {bool inStock = false}) async {
    emit(StoreDetailLoading());
    try {
      final detail = await repo.fetchStore(storeId, inStock: inStock);

      // Guardamos los productos originales para búsquedas
      _allProducts = detail.products;

      emit(StoreDetailLoaded(detail));
    } catch (e) {
      emit(StoreDetailError(e.toString()));
    }
  }

  void search(String query) {
    if (state is! StoreDetailLoaded) return;

    final current = state as StoreDetailLoaded;

    if (query.isEmpty) {
      // Restaurar la lista original
      emit(StoreDetailLoaded(
        StoreDetailModel(
          id: current.data.id,
          name: current.data.name,
          address: current.data.address,
          products: _allProducts,
        ),
      ));
      return;
    }

    final filtered = _allProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(StoreDetailLoaded(
      StoreDetailModel(
        id: current.data.id,
        name: current.data.name,
        address: current.data.address,
        products: filtered,
      ),
    ));
  }
}
