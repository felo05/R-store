import 'package:dartz/dartz.dart';


import 'package:e_commerce/features/orders/model/orders_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/features/orders/repository/i_orders_repository.dart';

import '../../../core/services/i_error_handler_service.dart';

class OrdersRepository implements IOrdersRepository {
  final IErrorHandlerService  _errorHandler;

  OrdersRepository(this._errorHandler);

  @override
  Future<Either<String, List<BaseOrders>>> getOrders(BuildContext context) async{
    try {
      if (FirebaseConstants.currentUserId == null) {
        return Left(_errorHandler.errorHandler('User not logged in', context));
      }

      final snapshot = await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.ordersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BaseOrders.fromJson(data);
      }).toList();

      return Right(orders);
    }catch(e){
      return Left(_errorHandler.errorHandler(e.toString(),context));
    }
  }
}