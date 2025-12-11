import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/features/home/models/prototype_products_model.dart';
import 'package:e_commerce/features/search/repository/i_search_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';

import '../../../core/services/i_error_handler_service.dart';

class SearchRepository implements ISearchRepository {
  final IErrorHandlerService _errorHandler;

  SearchRepository(this._errorHandler);

  @override
  Future<Either<String, BasePrototypeProductData>> search(
      String query, BuildContext context, {int? limit, dynamic lastDocument}) async {
    try {
      if (query.isEmpty) {
        return Right(BasePrototypeProductData(data: [], lastDocument: null));
      }

      final searchQuery = query.toLowerCase().trim();

      // Fetch all products from Firestore
      Query queryRef = FirebaseConstants.firestore
          .collection(FirebaseConstants.productsCollection);

      final snapshot = await queryRef.get();


      // Map all products
      final List<PrototypeProductData> allProducts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return PrototypeProductData.fromJson(data);
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

      return Right(BasePrototypeProductData(
        data: paginatedProducts,
        lastDocument: lastDocId,
      ));
    } catch (e) {
      return Left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
