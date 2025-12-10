import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';


abstract class IChangePasswordRepository {
  Future<Either<String, Unit>> changePassword(String oldPassword,String newPassword,BuildContext context);
}

