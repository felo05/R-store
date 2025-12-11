import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/features/cart/viewmodel/get_cart/cart_cubit.dart';
import 'package:e_commerce/features/home/viewmodel/products/products_cubit.dart';
import 'package:e_commerce/features/favorites/viewmodel/get_favorite_cubit.dart';
import 'package:e_commerce/features/checkout/repository/i_checkout_repository.dart';

import '../../../core/services/i_error_handler_service.dart';
import '../../../core/services/i_product_status_service.dart';

class CheckoutRepository implements ICheckoutRepository {
  final IErrorHandlerService  _errorHandler;
  final IProductStatusService _productStatusService;

  CheckoutRepository(this._errorHandler, this._productStatusService);

  @override
  Future<Either<String, Unit>> checkout(
      {required String paymentMethod,
      required String addressId,
      required BuildContext context}) async {
    try {
      if (FirebaseConstants.currentUserId == null) {
        return left(_errorHandler.errorHandler('User not logged in',context));
      }

      // Get cart items
      final cartSnapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.cartCollection)
          .get();

      if (cartSnapshot.docs.isEmpty) {
        return left(_errorHandler.errorHandler('Cart is empty',context));
      }

      // Calculate total from cart items
      num total = 0;
      List<Map<String, dynamic>> orderItems = [];

      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        final quantity = data['quantity'] as int? ?? 1;
        final product = data['product'] as Map<String, dynamic>?;
        final price = product?['price'] as num? ?? 0;

        total += price * quantity;

        // Store order items with necessary information
        orderItems.add({
          'product_id': doc.id,
          'name': product?['name'] ?? '',
          'price': price,
          'quantity': quantity,
          'image': product?['image'] ?? '',
        });
      }

      // Get address details
      final addressDoc = await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.addressesCollection)
          .doc(addressId)
          .get();

      // Create order
      await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.ordersCollection)
          .add({
        'address': addressDoc.exists ? addressDoc.data() : null,
        'addressId': addressId,
        'paymentMethod': int.tryParse(paymentMethod) ?? 1,
        'products': orderItems,
        'total': total,
        'status': 'pending',
        'date': DateTime.now().toString(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear cart after successful checkout
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }
      _productStatusService.clearCart();

      // Refresh cart, products, and favorites to update inCart flags
      context.read<CartCubit>().getCart(context);
      context.read<ProductsCubit>().getProducts(context);
      context.read<GetFavoriteCubit>().getFavorites(context);

      return right(unit);
    } catch (e) {
      return left(_errorHandler.errorHandler(e.toString(),context));
    }
  }
}
