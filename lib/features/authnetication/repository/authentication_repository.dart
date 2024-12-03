import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/errors/api_errors.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, ProfileModel>> login(String email, String password,BuildContext context);

  Future<Either<Failure, ProfileModel>> register(
      {required String name,
      required String password,
      required String email,
      required String phoneNum, required BuildContext context});

  void saveProfileDataLocally(ProfileData profile);
}
