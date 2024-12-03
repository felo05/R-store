import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/product_details/repository/product_details_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';

class ProductDetailsRepositoryImplementation
    implements ProductDetailsRepository {
  @override
  Future<Failure?> addToCart(
      int productId, int? quantity, BuildContext context) async {
    try {
      var response = await DioHelpers.postData(path: Kapi.cart, body: {
        'product_id': productId,
      });
      if(response.data["status"] == false) return (ServerFailure(response.data["message"]));
      if (quantity != null && quantity > 1) {
        response=await DioHelpers.putData(
            path: "${Kapi.cart}/${response.data["data"]["id"]}",
            body: {
              'quantity': quantity,
            });
      }
      if(response.data["status"] == false) return (ServerFailure(response.data["message"]));
      return null;
    } catch (e) {
      if (e is DioException) return ServerFailure.fromDioError(e, context);
      return ServerFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, ProductsModel>> getProducts(
      BuildContext context) async {
    try {
      final response = await DioHelpers.getData(path: Kapi.products);
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(ProductsModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e, context));
      return Left(ServerFailure(e.toString()));
    }
  }
}
