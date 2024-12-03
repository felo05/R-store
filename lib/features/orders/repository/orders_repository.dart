import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/orders/model/orders_model.dart';
import 'package:flutter/cupertino.dart';

abstract class OrdersRepository {
  Future<Either<Failure,List<BaseOrders>>> getOrders(BuildContext context);
}