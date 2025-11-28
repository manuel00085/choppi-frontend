import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'store_detail_repository.dart';
import 'store_detail_model.dart';

part 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final StoreDetailRepository repo;

  StoreDetailCubit(this.repo) : super(StoreDetailInitial());

  Future<void> loadDetail(int storeId) async {
    emit(StoreDetailLoading());
    try {
      final detail = await repo.fetchStore(storeId);
      emit(StoreDetailLoaded(detail));
    } catch (e) {
      emit(StoreDetailError(e.toString()));
    }
  }
}
