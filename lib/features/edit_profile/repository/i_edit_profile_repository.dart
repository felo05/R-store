import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';


abstract class IEditProfileRepository {
  Future<Either<String,Unit>> updateProfile(String name, String email, String phone,BuildContext context);
  void updateLocaleProfileData(String name, String email, String phone);
}

