import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';


abstract class ILogoutRepository {
  Future<Either<String, Unit>> logout(BuildContext context);

  void removeProfileDataLocally();
}

