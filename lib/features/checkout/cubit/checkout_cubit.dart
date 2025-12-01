import 'package:e_commerce/features/checkout/repository/checkout_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void checkout(
      {required String paymentMethod,
      required String addressId,
      required BuildContext context}) async {
    emit(CheckoutLoadingState());

    await CheckoutRepositoryImplementation()
        .checkout(
            paymentMethod: paymentMethod,
            addressId: addressId,
            context: context)
        .then((failure) {
      if (failure == null) {
        emit(CheckoutSuccessState());
      } else {
        emit(CheckoutErrorState(failure.errorMessage.toString()));
      }
    });
  }
}
