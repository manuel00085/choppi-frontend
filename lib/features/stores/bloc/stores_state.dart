part of 'stores_cubit.dart';

abstract class StoresState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoresInitial extends StoresState {}

class StoresLoading extends StoresState {}

class StoresLoaded extends StoresState {
  final List<StoreModel> stores;
  StoresLoaded(this.stores);

  @override
  List<Object?> get props => [stores];
}

class StoresError extends StoresState {
  final String message;
  StoresError(this.message);

  @override
  List<Object?> get props => [message];
}
