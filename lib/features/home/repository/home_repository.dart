import 'package:dartz/dartz.dart';


import 'package:e_commerce/features/home/models/banner_model.dart';

import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';

import '../../../core/services/i_error_handler_service.dart';
import '../../../core/services/i_product_status_service.dart';

class HomeRepository implements IHomeRepository {
  final IErrorHandlerService  _errorHandler;
  final IProductStatusService _productStatusService;

  HomeRepository(this._errorHandler, this._productStatusService);

  @override
  Future<Either<String, BannerModel>> getBanners(BuildContext context) async{
    try{
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.bannersCollection)
          .get();

      final banners = snapshot.docs.map((doc) => doc.data()).toList();

      return Right(BannerModel(
        status: true,
        message: null,
        data: banners.map((e) => BannerData.fromJson(e)).toList(),
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

      final categories = snapshot.docs.map((doc) => doc.data()).toList();

      return Right(CategoriesModel(
        status: true,
        message: null,
        data: BaseData(
          data: categories.map((e) => CategoriesData.fromJson(e)).toList(),
        ),
      ));
    }
    catch(e){
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

  @override
  Future<Either<String, BaseProductData>> getProducts(BuildContext context)async {
    try{
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection).limit(5)
          .get();

      // Get user's favorites and cart status using centralized service
      final statusMap = _productStatusService.getUserProductStatus();
      final favoriteIds = statusMap['favorites']!;
      final cartIds = statusMap['cart']!;

      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Set inFavorites and inCart flags based on user's collections
        data['in_favorites'] = favoriteIds.contains(doc.id);
        data['in_cart'] = cartIds.contains(doc.id);
        return data;
      }).toList();

      return Right(BaseProductData(
        data: products.map((e) => ProductData.fromJson(e)).toList(),
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