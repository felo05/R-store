part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsSuccessState extends ProductsState {
  final BaseProductData productData;
  ProductsSuccessState(this.productData);
}

final class ProductsErrorState extends ProductsState {
  final String errorMsg;
  ProductsErrorState(this.errorMsg);
}

final class ProductsLoadingState extends ProductsState {}