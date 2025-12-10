import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/features/favorites/repository/i_favorites_repository.dart';

import '../../../core/services/i_error_handler_service.dart';

class FavoritesRepository implements IFavoritesRepository {
  final IErrorHandlerService  _errorHandler;

  FavoritesRepository(this._errorHandler);

  @override
  Future<Either<String, FavoriteModel>> getFavorites(BuildContext context) async{
    try {
      if (FirebaseConstants.currentUserId == null) {
        return Left(_errorHandler.errorHandler('User not logged in',context));
      }

      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.favoritesCollection)
          .get();

      // Get user's cart
      Set<String> cartIds = {};
      final cartSnapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.cartCollection)
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
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }

  @override
  void addFavorite(String productID, BuildContext context, bool? isInHome,
      bool reloadAll) async {
    try {
      if (FirebaseConstants.currentUserId == null) return;

      final favRef = FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.favoritesCollection)
          .doc(productID.toString());

      final doc = await favRef.get();

      if (doc.exists) {
        // Remove from favorites
        await favRef.delete();
      } else {
        // Add to favorites
        final productDoc = await FirebaseConstants.firestore
            .collection(FirebaseConstants.productsCollection)
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
        debugPrint('Error toggling favorite: $e');
      }
    }
  }
}