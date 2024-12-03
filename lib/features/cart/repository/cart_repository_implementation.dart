import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import 'cart_repository.dart';

class CartRepositoryImplementation implements CartRepository {
  @override
  Future<Either<Failure, CartResponse>> getCartProducts(
      BuildContext context) async {
    try {
      final response = await DioHelpers.getData(path: Kapi.cart);
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(CartResponse.fromJson(response.data));
    } catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e, context));
      return Left(ServerFailure(e.toString()));
    }
  }
}
