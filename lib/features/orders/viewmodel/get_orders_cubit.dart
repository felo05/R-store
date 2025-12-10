import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/orders/repository/i_orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/features/orders/model/orders_model.dart';

part 'get_orders_state.dart';

class GetOrdersCubit extends Cubit<GetOrdersState> {
  final IOrdersRepository ordersRepository;

  GetOrdersCubit(this.ordersRepository) : super(GetOrdersInitial());

  void getOrders(BuildContext context) async {
    emit(GetOrdersLoadingState());
    (await ordersRepository.getOrders(context)).fold((failure) {
      emit(GetOrdersErrorState(failure.toString()));
    }, (data) {
      emit(GetOrdersSuccessState(data));
    });
  }
}
