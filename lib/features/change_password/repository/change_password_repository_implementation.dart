import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/core/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import 'change_password_repository.dart';

class ChangePasswordRepositoryImplementation
    implements ChangePasswordRepository {
  @override
  Future<Failure?> changePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    try {
      final response =
          await DioHelpers.postData(path: Kapi.changePassword, body: {
        "current_password": oldPassword,
        "new_password": newPassword,
      });
      if (response.data["status"] == false) return (ServerFailure(response.data["message"]));
      return null;
    } catch (e) {
      if (e is DioException) return (ServerFailure.fromDioError(e, context));
      return (ServerFailure(e.toString()));
    }
  }
}
