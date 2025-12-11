import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/search/repository/i_search_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';

import '../../../core/services/i_error_handler_service.dart';
import '../../../core/services/i_product_status_service.dart';

class SearchRepository implements ISearchRepository {
  final IErrorHandlerService _errorHandler;
  final IProductStatusService _productStatusService;

  SearchRepository(this._errorHandler, this._productStatusService);

  @override
  Future<Either<String, BaseProductData>> search(
      String query, BuildContext context, {int? limit, dynamic lastDocument}) async {
    try {
      if (query.isEmpty) {
        return Right(BaseProductData(data: [], lastDocument: null));
      }

      final searchQuery = query.toLowerCase().trim();

      // Fetch all products from Firestore
      Query queryRef = FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection);

      final snapshot = await queryRef.get();

      // Get user's favorites and cart status using centralized service
      final statusMap = _productStatusService.getUserProductStatus();
      final favoriteIds = statusMap['favorites']!;
      final cartIds = statusMap['cart']!;

      // Map all products
      final allProducts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['in_favorites'] = favoriteIds.contains(doc.id);
        data['in_cart'] = cartIds.contains(doc.id);
        return ProductData.fromJson(data);
      }).toList();

      // Client-side filter: Keep only products where name CONTAINS the search query (case-insensitive)
      final filteredProducts = allProducts.where((product) {
        final productName = product.name?.toLowerCase() ?? '';
        return productName.contains(searchQuery);
      }).toList();

      // Apply pagination to filtered results
      int startIndex = 0;
      if (lastDocument != null) {
        // Find the index after the last document ID
        final lastDocIndex = filteredProducts.indexWhere(
          (p) => p.id.toString() == lastDocument.toString()
        );
        if (lastDocIndex != -1) {
          startIndex = lastDocIndex + 1;
        }
      }

      // Get paginated subset
      final pageLimit = limit ?? 15;
      final endIndex = (startIndex + pageLimit).clamp(0, filteredProducts.length);

      final paginatedProducts = filteredProducts.sublist(startIndex, endIndex);

      // Determine last document ID for next page
      final lastDocId = paginatedProducts.isNotEmpty && endIndex < filteredProducts.length
          ? paginatedProducts.last.id
          : null;

      return Right(BaseProductData(
        data: paginatedProducts,
        lastDocument: lastDocId,
      ));
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
