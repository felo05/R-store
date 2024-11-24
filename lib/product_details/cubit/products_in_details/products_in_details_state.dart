part of 'products_in_details_cubit.dart';

@immutable
sealed class ProductsInDetailsState {}

final class ProductsInDetailsInitial extends ProductsInDetailsState {}

final class ProductsInDetailsErrorState extends ProductsInDetailsState {
  final String errorMsg;
  ProductsInDetailsErrorState(this.errorMsg);
}

final class ProductsInDetailsLoadingState extends ProductsInDetailsState {}

final class ProductsInDetailsSuccessState extends ProductsInDetailsState {}