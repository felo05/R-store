import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/material.dart';

abstract class LogoutRepository {
  Future<Failure?> logout(BuildContext context);

  void removeProfileDataLocally();
}
