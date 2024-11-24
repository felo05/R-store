import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../constants/kapi.dart';
import '../../../helpers/dio_helper.dart';
import '../../model/cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  CartResponse cartResponse = CartResponse();

  void getCart() async {
    emit(CartLoadingState());
    try {
      final response = await DioHelpers.getData(path: Kapi.cart);
      cartResponse = CartResponse.fromJson(response.data);

      if (cartResponse.status ?? false) {
        emit(CartSuccessState(cartResponse));
      } else {
        emit(CartErrorState(cartResponse.message!));
      }
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }
}
