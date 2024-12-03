import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

abstract class EditProfileRepository {
  Future<Failure?> updateProfile(String name, String email, String phone,BuildContext context);
  void updateLocaleProfileData(String name, String email, String phone);
}