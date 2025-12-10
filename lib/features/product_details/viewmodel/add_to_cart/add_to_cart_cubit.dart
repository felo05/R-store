import 'package:e_commerce/features/product_details/repository/i_product_details_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';

part 'add_to_cart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  final IProductDetailsRepository productDetailsRepository;

  AddToCartCubit(this.productDetailsRepository) : super(AddToCartInitial());

  void addToCart({
    required dynamic productId,
    int? quantity,
    required BuildContext context,
    required bool isInCartScreen,
  }) async {
    emit(AddToCartLoadingState());
    final result=await productDetailsRepository
        .addToCart(productId.toString(), quantity, context);
    result.fold(
          (failure) => emit(AddToCartErrorState(failure)),
          (_) => emit(AddToCartSuccessState()),
    );
  }

  static void removeFromCart({
    required dynamic productId,
    required BuildContext context,
  }) async {
    await sl<IProductDetailsRepository>()
        .deleteFromCart(productId.toString(), context);
  }
}
