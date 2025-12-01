import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/profile/repository/logout_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/firebase_helper.dart';
import '../../../core/helpers/hive_helper.dart';

class LogoutRepositoryImplementation implements LogoutRepository {
  @override
  Future<Failure?> logout(BuildContext context) async {
    try {
      await FirebaseHelper.auth.signOut();
      return Future.value(null);
    } catch (e) {
      return Future.value(ServerFailure(e.toString()));
    }
  }

  @override
  void removeProfileDataLocally() {
    HiveHelper.removeToken();
    HiveHelper.removeUser();
  }
}
