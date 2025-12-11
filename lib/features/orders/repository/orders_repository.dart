import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:e_commerce/features/orders/model/orders_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/features/orders/repository/i_orders_repository.dart';

import '../../../core/services/i_error_handler_service.dart';

class OrdersRepository implements IOrdersRepository {
  final IErrorHandlerService  _errorHandler;

  OrdersRepository(this._errorHandler);

  @override
  Future<Either<String, OrdersResponse>> getOrders(BuildContext context, {int? limit, dynamic lastDocument}) async{
    try {
      if (FirebaseConstants.currentUserId == null) {
        return Left(_errorHandler.errorHandler('User not logged in', context));
      }

      // Build query with pagination
      Query query = FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.ordersCollection)
          .orderBy('createdAt', descending: true);

      // Apply pagination if limit is provided
      if (limit != null) {
        query = query.limit(limit);
      }

      // If lastDocument is provided, start after it
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return BaseOrders.fromJson(data);
      }).toList();

      return Right(OrdersResponse(
        orders: orders,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      ));
    }catch(e){
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }
}