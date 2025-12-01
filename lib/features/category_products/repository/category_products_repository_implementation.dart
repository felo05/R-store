import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/firebase_helper.dart';
import 'category_products_repository.dart';

class CategoryProductsRepositoryImplementation
    implements CategoryProductsRepository {
  @override
  Future<Either<Failure, List<ProductData>>> getCategoryProducts(
      int categoryId, BuildContext context) async {
    try {
      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.productsCollection)
          .where('category_id', isEqualTo: categoryId)
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
        return ProductData.fromJson(data);
      }).toList();

      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
