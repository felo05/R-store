part of 'get_orders_cubit.dart';

@immutable
sealed class GetOrdersState {}

final class GetOrdersInitial extends GetOrdersState {}

final class GetOrdersErrorState extends GetOrdersState {
  final String error;

  GetOrdersErrorState(this.error);
}

final class GetOrdersLoadingState extends GetOrdersState {}

final class GetOrdersLoadingMoreState extends GetOrdersState {
  final List<BaseOrders> currentOrders;

  GetOrdersLoadingMoreState(this.currentOrders);
}

final class GetOrdersSuccessState extends GetOrdersState {
  final List<BaseOrders> orders;
  final dynamic lastDocument;

  GetOrdersSuccessState(this.orders, this.lastDocument);
}
