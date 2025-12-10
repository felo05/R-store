import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/cupertino.dart';

abstract class IAuthenticationRepository {
  Future<Either<String, ProfileModel>> login(String email, String password,BuildContext context);

  Future<Either<String, ProfileModel>> register(
      {required String name,
        required String password,
        required String email,
        required String phoneNum, required BuildContext context});

  void saveProfileDataLocally(ProfileData profile);
}