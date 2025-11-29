part of 'store_detail_cubit.dart';

abstract class StoreDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoreDetailInitial extends StoreDetailState {}

class StoreDetailLoading extends StoreDetailState {}

class StoreDetailLoaded extends StoreDetailState {
  final StoreDetailModel store;
  final List<StoreProductModel> products;
  final bool hasMore;
  final bool isLoadingMore;
  final String query;
  final bool inStock;

  StoreDetailLoaded({
    required this.store,
    required this.products,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.query = '',
    this.inStock = false,
  });

  StoreDetailLoaded copyWith({
    StoreDetailModel? store,
    List<StoreProductModel>? products,
    bool? hasMore,
    bool? isLoadingMore,
    String? query,
    bool? inStock,
  }) {
    return StoreDetailLoaded(
      store: store ?? this.store,
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
      inStock: inStock ?? this.inStock,
    );
  }

  @override
  List<Object?> get props => [store, products, hasMore, isLoadingMore, query, inStock];
}

class StoreDetailError extends StoreDetailState {
  final String message;
  StoreDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
