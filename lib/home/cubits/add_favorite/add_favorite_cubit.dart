import 'package:e_commerce/cart/cubit/get_cart/cart_cubit.dart';
import 'package:e_commerce/home/cubits/products/products_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/kapi.dart';
import '../../../favorites/cubit/get_favorite_cubit.dart';
import '../../../helpers/dio_helper.dart';

part 'add_favorite_state.dart';

class AddFavoriteCubit extends Cubit<AddFavoriteState> {
  AddFavoriteCubit() : super(AddFavoriteInitial());

  void addFavorite(int productID, BuildContext context, bool? isInHome,
      bool reloadAll) async {
    emit(AddFavoriteLoadingState());
    try {
      final response = await DioHelpers.postData(
          path: Kapi.favorites, body: {"product_id": productID});
      if (response.data['status']) {
        if (reloadAll) {
          context.read<GetFavoriteCubit>().getFavorites();
          context.read<ProductsCubit>().getProducts();
          context.read<CartCubit>().getCart();
        }
        {
          if(isInHome == null) {
            context.read<GetFavoriteCubit>().getFavorites();
            context.read<ProductsCubit>().getProducts();
          } else
          if (isInHome) {
            context.read<GetFavoriteCubit>().getFavorites();
            context.read<CartCubit>().getCart();
          } else {
            context.read<ProductsCubit>().getProducts();
            context.read<CartCubit>().getCart();
          }
        }
        emit(AddFavoriteSuccessState());
      }
    } catch (e) {
      emit(AddFavoriteErrorState(e.toString()));
    }
  }
}
