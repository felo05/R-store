import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/product_details/repository/product_details_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/firebase_helper.dart';

class ProductDetailsRepositoryImplementation
    implements ProductDetailsRepository {
  @override
  Future<Failure?> addToCart(
      String productId, int? quantity, BuildContext context) async {
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const ServerFailure('User not logged in');
      }

      final cartRef = FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.cartCollection)
          .doc(productId);

      final productDoc = await FirebaseHelper.firestore
          .collection(FirebaseHelper.productsCollection)
          .doc(productId)
          .get();

      if (!productDoc.exists) {
        return const ServerFailure('Product not found');
      }

      await cartRef.set({
        'product_id': productId,
        'product': productDoc.data(),
        'quantity': quantity ?? 1,
        'addedAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return ServerFailure(e.toString());
    }
  }

  @override
  Future<Failure?> deleteFromCart(String productId, BuildContext context) async {
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const ServerFailure('User not logged in');
      }

      await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.cartCollection)
          .doc(productId)
          .delete();

      return null;
    } catch (e) {
      return ServerFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, ProductsModel>> getProducts(
      BuildContext context) async {
    try {
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

      return Right(ProductsModel(
        status: true,
        message: null,
        data: BaseProductData(
          data: products.map((e) => ProductData.fromJson(e)).toList(),
        ),
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
