import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/orders/repository/orders_repository_implementation.dart';
import 'package:flutter/material.dart';

import '../model/orders_model.dart';

part 'get_orders_state.dart';

class GetOrdersCubit extends Cubit<GetOrdersState> {
  GetOrdersCubit() : super(GetOrdersInitial());

  void getOrders(BuildContext context) async {
    emit(GetOrdersLoadingState());
    (await OrdersRepositoryImplementation().getOrders(context)).fold((failure) {
      emit(GetOrdersErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(GetOrdersSuccessState(data));
    });
  }
}
