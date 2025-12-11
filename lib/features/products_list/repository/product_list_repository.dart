import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import '../../home/models/prototype_products_model.dart';
import '../model/products_list_model.dart';
import 'i_product_list_repository.dart';

class ProductsListRepository implements IProductsListRepository {
  final IErrorHandlerService _errorHandler;
  ProductsListRepository(this._errorHandler);

  @override
  Future<Either<String, ProductsListResponse>> getProducts(
      BuildContext context, {int? limit, dynamic lastDocument}) async {
    try {
      // Build query with pagination
      Query query = FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection);

      // Apply pagination if limit is provided
      if (limit != null) {
        query = query.limit(limit);
      }

      // If lastDocument is provided, start after it
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();


      final List<PrototypeProductData> products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return PrototypeProductData.fromJson(data);
      }).toList();

      return Right(ProductsListResponse(
        products: products,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      ));
    } catch (e) {
      if (context.mounted) {
        return Left(_errorHandler.errorHandler(e.toString(), context));
      }
      return Left(e.toString());
    }
  }
}
