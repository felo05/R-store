import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/search/repository/i_search_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';

import '../../../core/services/i_error_handler_service.dart';

class SearchRepository implements ISearchRepository {
  final IErrorHandlerService _errorHandler;

  SearchRepository(this._errorHandler);

  @override
  Future<Either<String, BaseProductData>> search(
      String query, BuildContext context) async {
    try {
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      // Get user's favorites and cart if logged in
      Set<String> favoriteIds = {};
      Set<String> cartIds = {};

      if (FirebaseConstants.currentUserId != null) {
        // Fetch user's favorites
        final favoritesSnapshot = await FirebaseConstants.firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(FirebaseConstants.currentUserId)
            .collection(FirebaseConstants.favoritesCollection)
            .get();

        favoriteIds = favoritesSnapshot.docs.map((doc) => doc.id).toSet();

        // Fetch user's cart
        final cartSnapshot = await FirebaseConstants.firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(FirebaseConstants.currentUserId)
            .collection(FirebaseConstants.cartCollection)
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
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
