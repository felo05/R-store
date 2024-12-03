import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import '../../../core/helpers/hive_helper.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/profile_screen.dart';
import 'edit_profile_repository.dart';

class EditProfileRepositoryImplementation implements EditProfileRepository {
  @override
  Future<Failure?> updateProfile(
      String name, String email, String phone, BuildContext context) async {
    try {
      final response=await DioHelpers.putData(path: Kapi.updateProfile, body: {
        'name': name,
        'email': email,
        'phone': phone,
        'image': null,
      });
      if(response.data["status"] == false) return (ServerFailure(response.data["message"]));

      return null;
    } catch (e) {
      if (e is DioException) return ServerFailure.fromDioError(e, context);
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
        image:
            "https://student.valuxapps.com/storage/assets/defaults/user.jpg");
    HiveHelper.setUser(newUserData);
    ProfileScreen.user = newUserData;
  }
}
