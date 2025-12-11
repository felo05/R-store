part of 'products_list_cubit.dart';

@immutable
sealed class ProductsListState {}

final class ProductsListInitial extends ProductsListState {}

final class ProductsListLoadingState extends ProductsListState {}

final class ProductsListLoadingMoreState extends ProductsListState {
  final List<ProductData> currentProducts;

  ProductsListLoadingMoreState(this.currentProducts);
}

final class ProductsListSuccessState extends ProductsListState {
  final List<ProductData> products;
  final dynamic lastDocument;

  ProductsListSuccessState(this.products, this.lastDocument);
}

final class ProductsListErrorState extends ProductsListState {
  final String error;

  ProductsListErrorState(this.error);
}

