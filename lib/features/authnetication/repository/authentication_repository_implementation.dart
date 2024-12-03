import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/kapi.dart';
import '../../../core/errors/api_errors.dart';
import '../../../core/helpers/dio_helper.dart';
import '../../../core/helpers/hive_helper.dart';
import 'authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  @override
  Future<Either<Failure, ProfileModel>> login(
      String email, String password, BuildContext context) async {
    try {
      final response = await DioHelpers.postData(
          path: Kapi.login, body: {"email": email, "password": password});
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(ProfileModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e,context));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  void saveProfileDataLocally(ProfileData profile) {
    HiveHelper.setToken(profile.token!);
    HiveHelper.setUser(profile);
  }

  @override
  Future<Either<Failure, ProfileModel>> register(
      {required String name,
      required String password,
      required String email,
      required String phoneNum, required BuildContext context}) async {
    try {
      final response = await DioHelpers.postData(path: Kapi.register, body: {
        "name": name,
        "phone": phoneNum,
        "email": email,
        "password": password,
        "image": null
      });
      if(response.data["status"] == false) return Left(ServerFailure(response.data["message"]));
      return Right(ProfileModel.fromJson(response.data));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e,context));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
