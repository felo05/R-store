import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/errors/api_errors.dart';

import 'package:e_commerce/features/home/models/banner_model.dart';

import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/firebase_helper.dart';
import 'home_repository.dart';

class HomeRepositoryImplementation implements HomeRepository {
  @override
  Future<Either<Failure, BannerModel>> getBanners(BuildContext context) async{
    try{
      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.bannersCollection)
          .get();

      final banners = snapshot.docs.map((doc) => doc.data()).toList();

      return Right(BannerModel(
        status: true,
        message: null,
        data: banners.map((e) => BannerData.fromJson(e)).toList(),
      ));
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoriesModel>> getCategories(BuildContext context) async{
    try{
      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.categoriesCollection)
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
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseProductData>> getProducts(BuildContext context)async {
    try{
      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.productsCollection)
          .get();

      // Get user's favorites and cart if logged in
      Set<String> favoriteIds = {};
      Set<String> cartIds = {};

      if (FirebaseHelper.currentUserId != null) {
        // Fetch user's favorites
        final favoritesSnapshot = await FirebaseHelper.firestore
            .collection(FirebaseHelper.usersCollection)
            .doc(FirebaseHelper.currentUserId)
            .collection(FirebaseHelper.favoritesCollection)
            .get();

        favoriteIds = favoritesSnapshot.docs.map((doc) => doc.id).toSet();

        // Fetch user's cart
        final cartSnapshot = await FirebaseHelper.firestore
            .collection(FirebaseHelper.usersCollection)
            .doc(FirebaseHelper.currentUserId)
            .collection(FirebaseHelper.cartCollection)
            .get();

        cartIds = cartSnapshot.docs.map((doc) => doc.id).toSet();
      }

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
      return Left(ServerFailure(e.toString()));
    }
  }
}