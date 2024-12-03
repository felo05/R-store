import 'package:e_commerce/features/change_password/repository/change_password_repository_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  void changePassword(String oldPassword, String newPassword, BuildContext context) async {
    emit(ChangePasswordLoadingState());
    await ChangePasswordRepositoryImplementation()
        .changePassword(oldPassword, newPassword,context)
        .then((failure) {
      if (failure == null) {
        emit(ChangePasswordSuccessState());
      } else {
        emit(ChangePasswordErrorState(failure.errorMessage.toString()));
      }
    });
  }
}
