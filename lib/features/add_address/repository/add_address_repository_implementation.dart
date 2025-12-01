import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/add_address/model/address_model.dart';
import 'package:flutter/material.dart';
import '../../../core/helpers/firebase_helper.dart';
import 'add_address_repository.dart';

class AddAddressRepositoryImplementation implements AddAddressRepository {
  @override
  Future<Failure?> addAddress(AddressData addressData, BuildContext context) async {
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const ServerFailure('User not logged in');
      }

      await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .collection(FirebaseHelper.addressesCollection)
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

      return null;
    } catch (e) {
      return ServerFailure(e.toString());
    }
  }
}
