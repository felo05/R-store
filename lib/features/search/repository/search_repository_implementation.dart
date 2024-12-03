import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/search/repository/search_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';

class SearchRepositoryImplementation implements SearchRepository {
  @override
  Future<Either<Failure, BaseProductData>> search(
      String query, BuildContext context) async {
    try {
      final response = await DioHelpers.postData(path: Kapi.search, body: {
        'text': query,
      });
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(BaseProductData.fromJson(response.data["data"]));
    } catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e, context));
      return Left(ServerFailure(e.toString()));
    }
  }
}
