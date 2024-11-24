import 'package:bloc/bloc.dart';
import 'package:e_commerce/constants/kapi.dart';
import 'package:meta/meta.dart';

import '../../helpers/dio_helper.dart';
import '../model/orders_model.dart';

part 'get_orders_state.dart';

class GetOrdersCubit extends Cubit<GetOrdersState> {
  GetOrdersCubit() : super(GetOrdersInitial());

  void getOrders() async {
    emit(GetOrdersLoadingState());
    try {
      final response = await DioHelpers.getData(path: Kapi.orders);
      if (response.data != null) {
        final ordersModel = OrdersModel.fromJson(response.data);
        if (ordersModel.status ?? false) {
          emit(GetOrdersSuccessState(ordersModel.baseData?.orders ?? []));
        } else {
          emit(GetOrdersErrorState(ordersModel.message ?? "Unknown error"));
        }
      } else {
        emit(GetOrdersErrorState("No data received from server."));
      }
    } catch (e) {
      emit(GetOrdersErrorState("Error fetching orders: $e"));
    }
  }

}
