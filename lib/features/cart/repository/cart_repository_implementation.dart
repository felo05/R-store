import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/firebase_helper.dart';
import 'cart_repository.dart';

class CartRepositoryImplementation implements CartRepository {
  @override
  Future<Either<Failure, CartResponse>> getCartProducts(
      BuildContext context) async {
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const Left(ServerFailure('User not logged in'));
      }

      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.cartCollection)
          .get();

      // Get user's favorites
      Set<String> favoriteIds = {};
      final favoritesSnapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.favoritesCollection)
          .get();

      favoriteIds = favoritesSnapshot.docs.map((doc) => doc.id).toSet();

      final cartItems = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Update product data with correct flags and ensure id is set
        if (data['product'] != null) {
          final productId = data['product']['id'] ?? doc.id;
          data['product']['id'] = productId; // Ensure product has id
          data['product']['in_favorites'] = favoriteIds.contains(productId);
          data['product']['in_cart'] = true; // Always true since it's in cart
        }
        return data;
      }).toList();

      // Parse cart items
      final parsedCartItems = cartItems.map((e) => CartItem.fromJson(e)).toList();

      // Calculate total from cart items
      num total = 0;
      for (var item in parsedCartItems) {
        total += (item.product.price ?? 0) * item.quantity;
      }

      return Right(CartResponse(
        status: true,
        message: null,
        data: CartData(
          cartItems: parsedCartItems,
          total: total,
        ),
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
