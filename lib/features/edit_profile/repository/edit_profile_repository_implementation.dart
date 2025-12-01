import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/helpers/firebase_helper.dart';
import '../../../core/helpers/hive_helper.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/profile_screen.dart';
import 'edit_profile_repository.dart';

class EditProfileRepositoryImplementation implements EditProfileRepository {
  @override
  Future<Failure?> updateProfile(
      String name, String email, String phone, BuildContext context) async {
    try {
      if (FirebaseHelper.currentUserId == null) {
        return const ServerFailure('User not logged in');
      }

      await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .update({
        'name': name,
        'email': email,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      return ServerFailure(e.toString());
    }
  }

  @override
  void updateLocaleProfileData(String name, String email, String phone) {
    ProfileData oldUserData = HiveHelper.getUser() ?? ProfileData();
    ProfileData newUserData = ProfileData(
        points: oldUserData.points,
        token: oldUserData.token,
        id: oldUserData.id,
        credit: oldUserData.credit,
        name: name,
        email: email,
        phone: phone,
        image: oldUserData.image);
    HiveHelper.setUser(newUserData);
    ProfileScreen.user = newUserData;
  }
}
