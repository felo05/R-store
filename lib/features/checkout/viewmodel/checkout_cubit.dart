import 'package:e_commerce/features/checkout/repository/i_checkout_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final ICheckoutRepository checkoutRepository;

  CheckoutCubit(this.checkoutRepository) : super(CheckoutInitial());

  void checkout(
      {required String paymentMethod,
      required String addressId,
      required BuildContext context}) async {
    emit(CheckoutLoadingState());

    final result = await checkoutRepository
        .checkout(
            paymentMethod: paymentMethod,
            addressId: addressId,
            context: context);
    result.fold(
          (failure) => emit(CheckoutErrorState(failure)),
          (_) => emit(CheckoutSuccessState()),
    );

  }
}
