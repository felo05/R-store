import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/services/i_error_handler_service.dart';
import 'package:e_commerce/core/services/i_storage_service.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/view/screens/profile_screen.dart';
import 'i_edit_profile_repository.dart';

class EditProfileRepository implements IEditProfileRepository {
  final IStorageService _storageService;
  final IErrorHandlerService _errorHandlerService;


  EditProfileRepository(this._storageService, this._errorHandlerService);

  @override
  Future<Either<String, Unit>> updateProfile(
      String name, String email, String phone, BuildContext context) async {
    try {
      if (FirebaseConstants.currentUserId == null) {
        return left(_errorHandlerService.errorHandler('User not logged in',context));
      }

      await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .update({
        'name': name,
        'email': email,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return right(unit);
    } catch (e) {
      return left(_errorHandlerService.errorHandler(e.toString(),context));
    }
  }

  @override
  void updateLocaleProfileData(String name, String email, String phone) {
    ProfileData oldUserData = _storageService.getUser() ?? ProfileData();
    ProfileData newUserData = ProfileData(
        points: oldUserData.points,
        token: oldUserData.token,
        id: oldUserData.id,
        credit: oldUserData.credit,
        name: name,
        email: email,
        phone: phone,
        image: oldUserData.image);
    _storageService.setUser(newUserData);
    ProfileScreen.user = newUserData;
  }
}
