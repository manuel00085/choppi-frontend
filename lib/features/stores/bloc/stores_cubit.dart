import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/store_model.dart';
import '../data/store_repository.dart';

part 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoreRepository repo;

  int page = 1;
  bool hasMore = true;
  bool loadingMore = false;
  String lastSearch = "";

  StoresCubit(this.repo) : super(StoresInitial());

  Future<void> loadStores({String search = ""}) async {
    emit(StoresLoading());

    page = 1;
    lastSearch = search;

    try {
      final result = await repo.fetchStores(page: page, search: search);

      // La fórmula correcta ⬇⬇⬇
      hasMore = result.page * result.limit < result.total;

      emit(StoresLoaded(result.data));
    } catch (e) {
      emit(StoresError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || loadingMore || state is StoresLoading) return;

    loadingMore = true;
    page++;

    try {
      final currentList = (state as StoresLoaded).stores;
      final result = await repo.fetchStores(page: page, search: lastSearch);

      final newList = [...currentList, ...result.data];

      // Verificación correcta ⬇⬇⬇
      hasMore = newList.length < result.total;

      emit(StoresLoaded(newList));
    } catch (e) {
      // Evitar romper la app si hay error
    }

    loadingMore = false;
  }
}
