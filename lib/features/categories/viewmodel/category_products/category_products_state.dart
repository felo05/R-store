part of 'category_products_cubit.dart';

@immutable
sealed class CategoryProductsState {}

final class CategoryProductsInitial extends CategoryProductsState {}

final class CategoryProductsLoadingState extends CategoryProductsState {}

final class CategoryProductsErrorState extends CategoryProductsState {
  final String message;

  CategoryProductsErrorState(this.message);
}

final class CategoryProductsSuccessState extends CategoryProductsState {

  final List<PrototypeProductData> products;

  CategoryProductsSuccessState(this.products);
}