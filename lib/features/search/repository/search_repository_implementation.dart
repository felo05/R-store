import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/search/repository/search_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/firebase_helper.dart';

class SearchRepositoryImplementation implements SearchRepository {
  @override
  Future<Either<Failure, BaseProductData>> search(
      String query, BuildContext context) async {
    try {
      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.productsCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
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

      return Right(BaseProductData(data: products));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
