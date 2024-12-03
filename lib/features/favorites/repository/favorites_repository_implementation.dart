import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import '../../cart/cubit/get_cart/cart_cubit.dart';
import '../../home/cubits/products/products_cubit.dart';
import '../cubit/get_favorites_cubit/get_favorite_cubit.dart';
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
    if (reloadAll) {
      context.read<GetFavoriteCubit>().getFavorites(context);
      context.read<ProductsCubit>().getProducts(context);
      context.read<CartCubit>().getCart(context);
    } else
    {
      if (isInHome == null) {
        context.read<GetFavoriteCubit>().getFavorites(context);
        context.read<ProductsCubit>().getProducts(context);
      } else if (isInHome) {
        context.read<GetFavoriteCubit>().getFavorites(context);
        context.read<CartCubit>().getCart(context);
      } else {
        context.read<ProductsCubit>().getProducts(context);
        context.read<CartCubit>().getCart(context);
      }
    }
  }
}