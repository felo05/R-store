import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/profile/repository/logout_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import '../../../core/helpers/hive_helper.dart';

class LogoutRepositoryImplementation implements LogoutRepository {
  @override
  Future<Failure?> logout(BuildContext context) async {
    try {
      final response=await DioHelpers.postData(
          path: Kapi.logout, body: {"fcm_token": "SomeFcmToken"});
      if(response.data["status"] == false) return (ServerFailure(response.data["message"]));
      return Future.value(null);
    } catch (e) {
      if (e is DioException) return ServerFailure.fromDioError(e,context);
      return Future.value(ServerFailure(e.toString()));
    }
  }

  @override
  void removeProfileDataLocally() {
    HiveHelper.removeToken();
    HiveHelper.removeUser();
  }
}
