import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/core/helpers/firebase_helper.dart';
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
      final productDoc = await FirebaseHelper.firestore
          .collection(FirebaseHelper.productsCollection)
          .doc(productID.toString())
          .get();

      if (!productDoc.exists) {
        return const Left(ServerFailure('Product not found'));
      }

      final data = productDoc.data()!;
      data['id'] = productDoc.id;
      return Right(ProductData.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
