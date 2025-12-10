import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import 'i_category_products_repository.dart';

class CategoryProductsRepository
    implements ICategoryProductsRepository {
  final IErrorHandlerService  _errorHandler;

  CategoryProductsRepository(this._errorHandler);

  @override
  Future<Either<String, List<ProductData>>> getCategoryProducts(
      int categoryId, BuildContext context) async {
    try {
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection)
          .where('category_id', isEqualTo: categoryId)
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
        data['in_favorites'] = favoriteIds.contains(doc.id);
        data['in_cart'] = cartIds.contains(doc.id);
        return ProductData.fromJson(data);
      }).toList();

      return Right(products);
    } catch (e) {
      return Left(_errorHandler.errorHandler(e, context));
    }
  }
}
