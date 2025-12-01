import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/errors/api_errors.dart';

import 'package:e_commerce/features/orders/model/orders_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/helpers/firebase_helper.dart';
import 'orders_repository.dart';

class OrdersRepositoryImplementation implements OrdersRepository {
  @override
  Future<Either<Failure, List<BaseOrders>>> getOrders(BuildContext context) async{
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const Left(ServerFailure('User not logged in'));
      }

      final snapshot = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.ordersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BaseOrders.fromJson(data);
      }).toList();

      return Right(orders);
    }catch(e){
      return Left(ServerFailure(e.toString()));
    }
  }
}