part of 'store_detail_cubit.dart';

abstract class StoreDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoreDetailInitial extends StoreDetailState {}

class StoreDetailLoading extends StoreDetailState {}

class StoreDetailLoaded extends StoreDetailState {
  final StoreDetailModel data;
  StoreDetailLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class StoreDetailError extends StoreDetailState {
  final String message;
  StoreDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
