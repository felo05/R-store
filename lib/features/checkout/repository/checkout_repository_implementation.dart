import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/firebase_helper.dart';
import '../../cart/cubit/get_cart/cart_cubit.dart';
import '../../home/cubits/products/products_cubit.dart';
import '../../favorites/cubit/get_favorites_cubit/get_favorite_cubit.dart';
import 'checkout_repository.dart';

class CheckoutRepositoryImplementation implements CheckoutRepository {
  @override
  Future<Failure?> checkout(
      {required String paymentMethod,
      required String addressId,
      required BuildContext context}) async {
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const ServerFailure('User not logged in');
      }

      // Get cart items
      final cartSnapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.cartCollection)
          .get();

      if (cartSnapshot.docs.isEmpty) {
        return const ServerFailure('Cart is empty');
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
      final addressDoc = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.addressesCollection)
          .doc(addressId)
          .get();

      // Create order
      await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.ordersCollection)
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

      // Refresh cart, products, and favorites to update inCart flags
      context.read<CartCubit>().getCart(context);
      context.read<ProductsCubit>().getProducts(context);
      context.read<GetFavoriteCubit>().getFavorites(context);

      return null;
    } catch (e) {
      return ServerFailure(e.toString());
    }
  }
}
