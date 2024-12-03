import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/constants/kapi.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/core/helpers/dio_helper.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/home/repository/home_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  Future<void> getProducts(BuildContext context) async {
    emit(ProductsLoadingState());
    (await HomeRepositoryImplementation().getProducts(context)).fold((failure) {
      emit(ProductsErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(ProductsSuccessState(data));
    });
  }

  static Future<Either<Failure, ProductData>> getAProduct(
      int productID, BuildContext context) async {
    try {
      final response =
          await DioHelpers.getData(path: '${Kapi.products}/$productID');
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(ProductData.fromJson(response.data['data']));
    } catch (e) {
      if (e is DioException) return Left(ServerFailure.fromDioError(e, context));
      return Left(ServerFailure(e.toString()));
    }
  }
}
