import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/services/i_error_handler_service.dart';
import 'package:e_commerce/features/add_address/model/address_model.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/firebase_constants.dart';
import 'i_add_address_repository.dart';

class AddAddressRepository implements IAddAddressRepository {
  final IErrorHandlerService _errorHandler;

  AddAddressRepository(this._errorHandler);

  @override
  Future<Either<String, Unit>> addAddress(AddressData addressData, BuildContext context) async {
    try {
      if (FirebaseConstants.currentUserId == null) {
        return left(_errorHandler.errorHandler('User not logged in', context));
      }

      await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .collection(FirebaseConstants.addressesCollection)
          .add({
        'latitude': addressData.latitude,
        'longitude': addressData.longitude,
        'notes': addressData.notes,
        'name': addressData.name,
        'details': addressData.details,
        'region': addressData.region,
        'city': addressData.city,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return right(unit);
    } catch (e) {
      return left(_errorHandler.errorHandler(e.toString(), context));
    }
  }
}
