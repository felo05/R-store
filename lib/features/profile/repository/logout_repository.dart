import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/services/i_error_handler_service.dart';
import 'package:e_commerce/core/services/i_storage_service.dart';
import 'package:e_commerce/features/profile/repository/i_logout_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';

class LogoutRepository implements ILogoutRepository {
  final IStorageService _storageService;
  final IErrorHandlerService _errorHandlerService;

  LogoutRepository(this._storageService, this._errorHandlerService);

  @override
  Future<Either<String, Unit>> logout(BuildContext context) async {
    try {
      await FirebaseConstants.auth.signOut();
      return Future.value(right(unit));
    } catch (e) {
      return Future.value(left(_errorHandlerService.errorHandler(e.toString(),context)));
    }
  }

  @override
  void removeProfileDataLocally() {
    _storageService.removeToken();
    _storageService.removeUser();
  }
}
