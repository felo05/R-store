part of 'add_to_cart_cubit.dart';

@immutable
sealed class AddToCartState {}

final class AddToCartInitial extends AddToCartState {}

final class AddToCartErrorState extends AddToCartState {
  final String errorMsg;
  AddToCartErrorState(this.errorMsg);
}

final class AddToCartLoadingState extends AddToCartState {}

final class AddToCartSuccessState extends AddToCartState {}
