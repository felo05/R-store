import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/orders/repository/i_orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/features/orders/model/orders_model.dart';

part 'get_orders_state.dart';

class GetOrdersCubit extends Cubit<GetOrdersState> {
  final IOrdersRepository ordersRepository;
  static const int itemsPerPage = 15;

  GetOrdersCubit(this.ordersRepository) : super(GetOrdersInitial());

  void getOrders(BuildContext context) async {
    emit(GetOrdersLoadingState());
    (await ordersRepository.getOrders(context, limit: itemsPerPage)).fold((failure) {
      emit(GetOrdersErrorState(failure.toString()));
    }, (response) {
      emit(GetOrdersSuccessState(response.orders ?? [], response.lastDocument));
    });
  }

  Future<void> loadMoreOrders(BuildContext context, List<BaseOrders> currentOrders, dynamic lastDocument) async {
    if (lastDocument == null) return;

    emit(GetOrdersLoadingMoreState(currentOrders));

    (await ordersRepository.getOrders(context, limit: itemsPerPage, lastDocument: lastDocument)).fold(
      (failure) {
        emit(GetOrdersSuccessState(currentOrders, lastDocument)); // Keep current data on error
      },
      (response) {
        final List<BaseOrders> allOrders = [...currentOrders, ...(response.orders ?? <BaseOrders>[])];
        emit(GetOrdersSuccessState(allOrders, response.lastDocument));
      }
    );
  }
}
