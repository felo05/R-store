import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

abstract class ChangePasswordRepository {
  Future<Failure?> changePassword(String oldPassword,String newPassword,BuildContext context);
}