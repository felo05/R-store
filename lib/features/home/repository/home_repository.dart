import 'package:dartz/dartz.dart';


import 'package:e_commerce/features/home/models/banner_model.dart';

import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:e_commerce/features/home/models/prototype_products_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';

import '../../../core/services/i_error_handler_service.dart';
import '../../product_details/model/product_model.dart';

class HomeRepository implements IHomeRepository {
  final IErrorHandlerService  _errorHandler;

  HomeRepository(this._errorHandler);

  @override
  Future<Either<String, BannerModel>> getBanners(BuildContext context) async{
    try{
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.bannersCollection)
          .get();

      final List<BannerData> banners = snapshot.docs.map((doc) => BannerData.fromJson(doc.data())).toList();

      return Right(BannerModel(
        status: true,
        message: null,
        data: banners,
      ));
    }catch(e){
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

  @override
  Future<Either<String, CategoriesModel>> getCategories(BuildContext context) async{
    try{
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.categoriesCollection).limit(4)
          .get();

      final List<CategoriesData> categories = snapshot.docs.map((doc) => CategoriesData.fromJson(doc.data())).toList();

      return Right(CategoriesModel(
        status: true,
        message: null,
        data: BaseData(
          data: categories,
        ),
      ));
    }
    catch(e){
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

  @override
  Future<Either<String, BasePrototypeProductData>> getProducts(BuildContext context)async {
    try{
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection).limit(5)
          .get();

      final List<PrototypeProductData> products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return PrototypeProductData.fromJson(data);
      }).toList();

      return Right(BasePrototypeProductData(
        data: products,
      ));
    }
    catch(e){
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

   @override
  Future<Either<String, ProductData>> getAProduct(
      int productID, BuildContext context) async {
    try {
      final productDoc = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection)
          .doc(productID.toString())
          .get();

      if (!productDoc.exists) {
        return  Left(_errorHandler.errorHandler('Product not found',context));
      }

      final data = productDoc.data()!;
      data['id'] = productDoc.id;
      return Right(ProductData.fromJson(data));
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }


}