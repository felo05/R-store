part of 'get_product_cubit.dart';

@immutable
sealed class GetProductState {}

final class GetProductInitial extends GetProductState {}

final class GetProductLoadingState extends GetProductState {}

final class GetProductErrorState extends GetProductState {
  final String errorMsg;
  GetProductErrorState(this.errorMsg);
}

final class GetProductSuccessState extends GetProductState {
  final ProductData product;
  GetProductSuccessState(this.product);
}

