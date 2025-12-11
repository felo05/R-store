import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/services/i_product_status_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import '../../home/models/products_model.dart';
import '../model/products_list_model.dart';
import 'i_product_list_repository.dart';

class ProductsListRepository implements IProductsListRepository {
  final IErrorHandlerService _errorHandler;
  final IProductStatusService _productStatusService;
  ProductsListRepository(this._errorHandler, this._productStatusService);

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

      // Get user's favorites and cart if logged in
      final statusMap = _productStatusService.getUserProductStatus();
      Set<String> favoriteIds = statusMap['favorites']!;
      Set<String> cartIds = statusMap['cart']!;

      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['in_favorites'] = favoriteIds.contains(doc.id);
        data['in_cart'] = cartIds.contains(doc.id);
        return ProductData.fromJson(data);
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
