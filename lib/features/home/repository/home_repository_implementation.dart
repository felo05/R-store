import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:e_commerce/core/errors/api_errors.dart';

import 'package:e_commerce/features/home/models/banner_model.dart';

import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import 'home_repository.dart';

class HomeRepositoryImplementation implements HomeRepository {
  @override
  Future<Either<Failure, BannerModel>> getBanners(BuildContext context) async{
    try{
    final response = await DioHelpers.getData(path: Kapi.banners);
    if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
    return Right(BannerModel.fromJson(response.data));
    }catch(e){
      if(e is DioException) return Left(ServerFailure.fromDioError(e,context));
      return Left(ServerFailure(e.toString()));
    }

  }

  @override
  Future<Either<Failure, CategoriesModel>> getCategories(BuildContext context) async{
    try{
    final response = await DioHelpers.getData(path: Kapi.categories);
    if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
    return Right(CategoriesModel.fromJson(response.data));
    }
    catch(e){
      if(e is DioException) return Left(ServerFailure.fromDioError(e,context));
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseProductData>> getProducts(BuildContext context)async {
    try{
      final response = await DioHelpers.getData(path: Kapi.products);
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(BaseProductData.fromJson(response.data['data']));
    }
    catch(e){
      if(e is DioException) return Left(ServerFailure.fromDioError(e,context));
      return Left(ServerFailure(e.toString()));
    }
  }
}