import 'package:e_commerce/features/product_details/repository/product_details_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_to_cart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  AddToCartCubit() : super(AddToCartInitial());

  void addToCart({
    required int productId,
    int? quantity,
    required BuildContext context,
    required bool isInCartScreen,
  }) async {
    emit(AddToCartLoadingState());
    await ProductDetailsRepositoryImplementation()
        .addToCart(productId, quantity, context)
        .then((failure) {
      if (failure == null) {

        emit(AddToCartSuccessState());
      } else {
        emit(AddToCartErrorState(failure.errorMessage.toString()));
      }
    });
  }
  static void removeFromCart({
    required int productId,
    required BuildContext context,
  }) async {
    await ProductDetailsRepositoryImplementation()
        .addToCart(productId, 0, context);
  }
}
