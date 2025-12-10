import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/product_details/repository/i_product_details_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';

import '../../../core/services/i_error_handler_service.dart';

class ProductDetailsRepository
    implements IProductDetailsRepository {
  final IErrorHandlerService  _errorHandler;

  ProductDetailsRepository(this._errorHandler);

  @override
  Future<Either<String, Unit>> addToCart(
      String productId, int? quantity, BuildContext context) async {
    try {
      if (FirebaseConstants.currentUserId == null) {
        return left(_errorHandler.errorHandler('User not logged in',context));
      }

      final cartRef = FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.cartCollection)
          .doc(productId);

      final productDoc = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection)
          .doc(productId)
          .get();

      if (!productDoc.exists) {
        return left(_errorHandler.errorHandler('Product not found',context));
      }

      await cartRef.set({
        'product_id': productId,
        'product': productDoc.data(),
        'quantity': quantity ?? 1,
        'addedAt': FieldValue.serverTimestamp(),
      });

      return right(unit);
    } catch (e) {
      return left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

  @override
  Future<Either<String, Unit>> deleteFromCart(String productId, BuildContext context) async {
    try {
      if (FirebaseConstants.currentUserId == null) {
        return left(_errorHandler.errorHandler('User not logged in',context));
      }

      await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.cartCollection)
          .doc(productId)
          .delete();

      return right(unit);
    } catch (e) {
      return left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

  @override
  Future<Either<String, ProductsModel>> getProducts(
      BuildContext context) async {
    try {
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection)
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
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

  @override
  Future<Either<String, ProductData>> getProduct(
      int productId, BuildContext context) async {
    try {
      final productDoc = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection)
          .doc(productId.toString())
          .get();

      if (!productDoc.exists) {
        return Left(_errorHandler.errorHandler('Product not found', context));
      }

      final data = productDoc.data()!;
      data['id'] = productDoc.id;

      // Check if product is in favorites and cart
      if (FirebaseConstants.currentUserId != null) {
        final favoriteDoc = await FirebaseConstants.firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(FirebaseConstants.currentUserId)
            .collection(FirebaseConstants.favoritesCollection)
            .doc(productId.toString())
            .get();

        data['in_favorites'] = favoriteDoc.exists;

        final cartDoc = await FirebaseConstants.firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(FirebaseConstants.currentUserId)
            .collection(FirebaseConstants.cartCollection)
            .doc(productId.toString())
            .get();

        data['in_cart'] = cartDoc.exists;
      } else {
        data['in_favorites'] = false;
        data['in_cart'] = false;
      }

      return Right(ProductData.fromJson(data));
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
