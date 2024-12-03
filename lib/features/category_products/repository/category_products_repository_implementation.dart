import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import 'category_products_repository.dart';

class CategoryProductsRepositoryImplementation
    implements CategoryProductsRepository {
  @override
  Future<Either<Failure, List<ProductData>>> getCategoryProducts(
      int categoryId, BuildContext context) async {
    try {
      final response =
          await DioHelpers.getData(path: "${Kapi.categories}/$categoryId");
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(BaseProductData.fromJson(response.data["data"]).data!);
    } catch (e) {
      if(e is DioException)return Left(ServerFailure.fromDioError(e, context));
      return Left(ServerFailure(e.toString()));
    }
  }
}
