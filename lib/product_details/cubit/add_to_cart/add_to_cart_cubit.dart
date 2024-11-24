import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/cubit/get_cart/cart_cubit.dart';
import '../../../constants/kapi.dart';
import '../../../favorites/cubit/get_favorite_cubit.dart';
import '../../../home/cubits/products/products_cubit.dart';

part 'add_to_cart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  AddToCartCubit() : super(AddToCartInitial());

  void addToCart({
    required int productId,
     int? quantity,
    required BuildContext context,
    required isInCart,
  }) async {
    emit(AddToCartLoadingState());
    try {
      final response = await DioHelpers.postData(path: Kapi.cart, body: {
        'product_id': productId,
      });


      if (quantity!=null && quantity > 1) {
        await DioHelpers.putData(
            path: "${Kapi.cart}/${response.data["data"]["id"]}",
            body: {
              'quantity': quantity,
            });
      }
      if(!isInCart){
        context.read<CartCubit>().getCart();
      }
      context.read<GetFavoriteCubit>().getFavorites();
      context.read<ProductsCubit>().getProducts();
      emit(AddToCartSuccessState());
    } catch (e) {
      emit(AddToCartErrorState(e.toString()));
    }
  }
}
