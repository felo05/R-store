part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartErrorState extends CartState {
  final String msg;

  CartErrorState(this.msg);
}

final class CartLoadingState extends CartState {}

final class CartSuccessState extends CartState {
  final CartData cartResponse;

  CartSuccessState(this.cartResponse);
}
