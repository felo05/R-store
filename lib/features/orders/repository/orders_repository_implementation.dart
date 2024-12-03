import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:e_commerce/core/errors/api_errors.dart';

import 'package:e_commerce/features/orders/model/orders_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import 'orders_repository.dart';

class OrdersRepositoryImplementation implements OrdersRepository {
  @override
  Future<Either<Failure, List<BaseOrders>>> getOrders(BuildContext context) async{
    try {
      final response = await DioHelpers.getData(path: Kapi.orders);
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(OrdersModel.fromJson(response.data).baseData?.orders ?? []);
    }catch(e){
      if(e is DioException) return Left(ServerFailure.fromDioError(e, context));
      return Left(ServerFailure(e.toString()));
    }
  }
}