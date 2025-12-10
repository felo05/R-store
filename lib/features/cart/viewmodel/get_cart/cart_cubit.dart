import 'package:e_commerce/features/cart/repository/i_cart_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final ICartRepository cartRepository;

  CartCubit(this.cartRepository) : super(CartInitial());

  void getCart(BuildContext context) async {
    emit(CartLoadingState());
    (await cartRepository.getCartProducts(context)).fold((failure){
      emit(CartErrorState(failure.toString()));
    }, (data){
      emit(CartSuccessState(data.data!));
    });
  }

  void emitSuccessState(CartData data){
    emit(CartSuccessState(data));
  }

  void changeQuantityCloudly({required int quantity, required String productId}) async {
    cartRepository.changeQuantityCloudly(quantity: quantity, productId: productId);
  }

  /// Update quantity for a specific cart item and recalculate total
  void updateQuantity({required String productId, required int newQuantity}) {
    final currentState = state;
    if (currentState is CartSuccessState) {
      final cartItems = currentState.cartResponse.cartItems ?? [];
      final updatedItems = cartItems.map((item) {
        if (item.id == productId) {
          // Create new CartItem with updated quantity
          return CartItem(
            id: item.id,
            quantity: newQuantity,
            product: item.product,
          );
        }
        return item;
      }).toList();

      // Recalculate total
      num newTotal = 0;
      for (var item in updatedItems) {
        newTotal += (item.product.price ?? 0) * item.quantity;
      }

      // Update cloud storage
      changeQuantityCloudly(quantity: newQuantity, productId: productId);

      // Emit updated state
      emitSuccessState(
        CartData(cartItems: updatedItems, total: newTotal),
      );
    }
  }

  /// Remove item from cart and recalculate total
  void removeItem(String productId) {
    final currentState = state;
    if (currentState is CartSuccessState) {
      final cartItems = currentState.cartResponse.cartItems ?? [];
      final updatedItems = cartItems.where((item) => item.id != productId).toList();

      // Recalculate total
      num newTotal = 0;
      for (var item in updatedItems) {
        newTotal += (item.product.price ?? 0) * item.quantity;
      }

      // Emit updated state
      emitSuccessState(
        CartData(cartItems: updatedItems, total: newTotal),
      );
    }
  }
}
