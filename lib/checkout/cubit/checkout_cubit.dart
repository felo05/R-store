import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../cart/cubit/get_cart/cart_cubit.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void checkout({required int paymentMethod, required int addressId,required BuildContext context}) async {
    emit(CheckoutLoadingState());
    try {
      await DioHelpers.postData(path: Kapi.orders, body: {
        "address_id": addressId,
        "payment_method": paymentMethod,
        "use_points": false,
        "promo_code_id": null
      });
      context.read<CartCubit>().getCart();
      emit(CheckoutSuccessState());
    } catch (e) {
      emit(CheckoutErrorState(e.toString()));
    }
  }
}
