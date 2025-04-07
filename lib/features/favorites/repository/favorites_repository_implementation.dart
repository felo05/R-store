import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImplementation implements FavoritesRepository {


  @override
  Future<Either<Failure, FavoriteModel>> getFavorites(BuildContext context) async{
    try {
      final response = await DioHelpers.getData(path: Kapi.favorites);
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(FavoriteModel.fromJson(response.data));
    }catch(e){
      if(e is DioException) return Left(ServerFailure.fromDioError(e,context));
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  void addFavorite(int productID, BuildContext context, bool? isInHome,
      bool reloadAll) async {
     await DioHelpers.postData(
        path: Kapi.favorites, body: {"product_id": productID});
  }
}