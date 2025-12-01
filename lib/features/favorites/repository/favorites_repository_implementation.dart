import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../core/helpers/firebase_helper.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImplementation implements FavoritesRepository {

  @override
  Future<Either<Failure, FavoriteModel>> getFavorites(BuildContext context) async{
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const Left(ServerFailure('User not logged in'));
      }

      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.favoritesCollection)
          .get();

      // Get user's cart
      Set<String> cartIds = {};
      final cartSnapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.cartCollection)
          .get();

      cartIds = cartSnapshot.docs.map((doc) => doc.id).toSet();

      final favorites = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Update product data with correct flags and ensure id is set
        if (data['product'] != null) {
          final productId = data['product']['id'] ?? doc.id;
          data['product']['id'] = productId; // Ensure product has id
          data['product']['in_favorites'] = true; // Always true since it's in favorites
          data['product']['in_cart'] = cartIds.contains(productId);
        }
        return FavoriteData.fromJson(data);
      }).toList();

      return Right(FavoriteModel(
        status: true,
        message: null,
        data: FavoriteDataList(
          data: favorites,
        ),
      ));
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  void addFavorite(String productID, BuildContext context, bool? isInHome,
      bool reloadAll) async {
    try {
      if (FirebaseHelper.currentUserId == null) return;

      final favRef = FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.favoritesCollection)
          .doc(productID.toString());

      final doc = await favRef.get();

      if (doc.exists) {
        // Remove from favorites
        await favRef.delete();
      } else {
        // Add to favorites
        final productDoc = await FirebaseHelper.firestore
            .collection(FirebaseHelper.productsCollection)
            .doc(productID.toString())
            .get();

        if (productDoc.exists) {
          await favRef.set({
            'product_id': productID,
            'product': productDoc.data(),
            'addedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
            print('Error toggling favorite: $e');
      }
    }
  }
}