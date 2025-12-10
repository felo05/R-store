import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/services/i_error_handler_service.dart';
import 'i_change_password_repository.dart';

class ChangePasswordRepository
    implements IChangePasswordRepository {
  final IErrorHandlerService  _errorHandler;

  ChangePasswordRepository(this._errorHandler);

  @override
  Future<Either<String, Unit>> changePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    try {
      final user = FirebaseConstants.auth.currentUser;
      if (user == null) {
        return left(_errorHandler.errorHandler('User not logged in',context));
      }

      // Re-authenticate user with old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      return right(unit);
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
      return left(_errorHandler.errorHandler(message,context));
    } catch (e) {
      return left(_errorHandler.errorHandler(e.toString(),context));
    }
  }
}
