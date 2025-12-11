import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/home/models/prototype_products_model.dart';
import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import 'i_categories_repository.dart';

class CategoriesRepository implements ICategoriesRepository {
  final IErrorHandlerService _errorHandler;


  CategoriesRepository(this._errorHandler);

  @override
  Future<Either<String, CategoriesResponse>> getCategories(
      BuildContext context, {int? limit, dynamic lastDocument}) async {
    try {
      // Build query with pagination
      Query query = FirebaseConstants.firestore
          .collection(FirebaseConstants.categoriesCollection);

      // Apply pagination if limit is provided
      if (limit != null) {
        query = query.limit(limit);
      }

      // If lastDocument is provided, start after it
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      final categories = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return CategoriesData.fromJson(data);
      }).toList();

      return Right(CategoriesResponse(
        categories: categories,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      ));
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }

  @override
  Future<Either<String, List<PrototypeProductData>>> getCategoryProducts(
      int categoryId, BuildContext context) async {
    try {
      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection)
          .where('category_id', isEqualTo: categoryId)
          .get();


      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return PrototypeProductData.fromJson(data);
      }).toList();

      return Right(products);
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
