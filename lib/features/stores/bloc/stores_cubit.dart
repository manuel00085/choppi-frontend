import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/store_repository.dart';
import '../data/store_model.dart';

part 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoreRepository repo;

  StoresCubit(this.repo) : super(StoresInitial());

  Future<void> loadStores({String? search}) async {
    emit(StoresLoading());
    try {
      final stores = await repo.fetchStores(page: 1, search: search);
      emit(StoresLoaded(stores));
    } catch (e) {
      emit(StoresError(e.toString()));
    }
  }
}
