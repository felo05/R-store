import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/features/favorites/repository/i_favorites_repository.dart';

import '../../../core/services/i_error_handler_service.dart';
import '../../../core/services/i_product_status_service.dart';

class FavoritesRepository implements IFavoritesRepository {
  final IErrorHandlerService  _errorHandler;
  final IProductStatusService _productStatusService;

  FavoritesRepository(this._errorHandler, this._productStatusService);

  @override
  Future<Either<String, FavoriteModel>> getFavorites(BuildContext context, {int? limit, dynamic lastDocument}) async{
    try {
      if (FirebaseConstants.currentUserId == null) {
        return Left(_errorHandler.errorHandler('User not logged in',context));
      }

      // Build query with pagination
      Query query = FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.favoritesCollection)
          .orderBy('addedAt', descending: true);

      // Apply pagination if limit is provided
      if (limit != null) {
        query = query.limit(limit);
      }

      // If lastDocument is provided, start after it
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();


      final favorites = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        if (data['product'] != null && data['product'] is Map) {
          final product = data['product'] as Map<String, dynamic>;
          final productId = product['id'] ?? doc.id;
          product['id'] = productId; // Ensure product has id
          data['product'] = product;
        }
        return FavoriteData.fromJson(data);
      }).toList();

      return Right(FavoriteModel(
        status: true,
        message: null,
        data: FavoriteDataList(
          data: favorites,
          lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
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
         _productStatusService.removeProductFromFavorites(productID);
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
         _productStatusService.addProductToFavorites(productID);

      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error toggling favorite: $e');
      }
    }
  }
}