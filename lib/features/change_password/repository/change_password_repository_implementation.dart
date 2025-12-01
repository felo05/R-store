import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/material.dart';

import '../../../core/helpers/firebase_helper.dart';
import 'change_password_repository.dart';

class ChangePasswordRepositoryImplementation
    implements ChangePasswordRepository {
  @override
  Future<Failure?> changePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    try {
      final user = FirebaseHelper.auth.currentUser;
      if (user == null) {
        return const ServerFailure('User not logged in');
      }

      // Re-authenticate user with old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      return null;
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'wrong-password':
          message = 'Current password is incorrect';
          break;
        case 'weak-password':
          message = 'New password is too weak';
          break;
        default:
          message = e.message ?? 'Failed to change password';
      }
      return ServerFailure(message);
    } catch (e) {
      return ServerFailure(e.toString());
    }
  }
}
