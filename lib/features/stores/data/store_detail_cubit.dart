import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'store_detail_repository.dart';
import 'store_detail_model.dart';
import 'store_product_model.dart';

part 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final StoreDetailRepository repo;
  final List<StoreProductModel> _products = [];
  int _storeId = 0;
  int _page = 1;
  bool _hasMore = true;
  String _query = '';
  bool _inStock = false;

  StoreDetailCubit(this.repo) : super(StoreDetailInitial());

  Future<void> loadDetail(int storeId, {bool? inStock, String? query}) async {
    emit(StoreDetailLoading());

    _storeId = storeId;
    _page = 1;
    _query = query ?? _query;
    _inStock = inStock ?? _inStock;
    _products.clear();
    _hasMore = true;

    await _fetchPage(resetStore: true);
  }

  Future<void> _fetchPage({bool resetStore = false}) async {
    try {
      final detail = await repo.fetchStore(
        _storeId,
        inStock: _inStock,
        query: _query,
        page: _page,
      );

      if (!resetStore && state is StoreDetailLoaded) {
        _products.addAll(detail.products);
      } else {
        _products
          ..clear()
          ..addAll(detail.products);
      }

      _hasMore = _products.length < detail.total;

      emit(StoreDetailLoaded(
        store: detail,
        products: List.unmodifiable(_products),
        hasMore: _hasMore,
        isLoadingMore: false,
        query: _query,
        inStock: _inStock,
      ));
    } catch (e) {
      emit(StoreDetailError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state is! StoreDetailLoaded || !_hasMore) return;
    final current = state as StoreDetailLoaded;
    if (current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    _page += 1;
    await _fetchPage();
  }

  Future<void> refresh() async {
    if (_storeId == 0) return;
    await loadDetail(_storeId, inStock: _inStock, query: _query);
  }

  void search(String query) {
    _query = query;
    loadDetail(_storeId, inStock: _inStock, query: _query);
  }
}
