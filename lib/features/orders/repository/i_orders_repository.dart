import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/orders/model/orders_model.dart';
import 'package:flutter/cupertino.dart';


abstract class IOrdersRepository {
  Future<Either<String,List<BaseOrders>>> getOrders(BuildContext context);
}

