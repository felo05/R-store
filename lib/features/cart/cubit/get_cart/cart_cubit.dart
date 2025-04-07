import 'package:e_commerce/features/cart/repository/cart_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/kapi.dart';
import '../../../../core/helpers/dio_helper.dart';
import '../../model/cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void getCart(BuildContext context) async {
    emit(CartLoadingState());
    (await CartRepositoryImplementation().getCartProducts(context)).fold((failure){
      emit(CartErrorState(failure.errorMessage.toString()));
    }, (data){

      emit(CartSuccessState(data.data!));
    });
  }
  void emitSuccessState(CartData data){
    emit(CartSuccessState(data));
  }
  static void changeQuantityCloudly({required int quantity, required int productId}) async {
    await DioHelpers.putData(path: "${Kapi.cart}/$productId", body: {
      'quantity': quantity,
    });
  }
}
