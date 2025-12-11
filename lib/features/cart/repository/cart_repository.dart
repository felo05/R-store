import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import '../../../core/services/i_product_status_service.dart';
import 'i_cart_repository.dart';

class CartRepository implements ICartRepository {
  final IErrorHandlerService  _errorHandler;
  final IProductStatusService _productStatusService;

  CartRepository(this._errorHandler, this._productStatusService);

  @override
  Future<Either<String, CartResponse>> getCartProducts(
      BuildContext context) async {
    try {
      if (FirebaseConstants.currentUserId == null) {
        return Left(_errorHandler.errorHandler('User not logged in',context));
      }

      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.cartCollection)
          .get();


      final cartItems = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Update product data with correct flags and ensure id is set
        if (data['product'] != null) {
          final productId = data['product']['id'] ?? doc.id;
          data['product']['id'] = productId; // Ensure product has id
          data['product']['in_favorites'] = _productStatusService.isInFavorite(productId);
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
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

   @override
  void changeQuantityCloudly({required int quantity, required String productId}) async {
    if (FirebaseConstants.currentUserId == null) return;
    await FirebaseConstants.firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(FirebaseConstants.currentUserId)
        .collection(FirebaseConstants.cartCollection)
        .doc(productId.toString())
        .update({
      'quantity': quantity,
    });

  }
}