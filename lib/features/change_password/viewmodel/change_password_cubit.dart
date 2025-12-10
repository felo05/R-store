import 'package:e_commerce/features/change_password/repository/i_change_password_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final IChangePasswordRepository changePasswordRepository;

  ChangePasswordCubit(this.changePasswordRepository) : super(ChangePasswordInitial());

  void changePassword(String oldPassword, String newPassword, BuildContext context) async {
    emit(ChangePasswordLoadingState());
    final result=await changePasswordRepository
        .changePassword(oldPassword, newPassword,context);
    result.fold(
          (failure) => emit(ChangePasswordErrorState(failure)),
          (_) => emit(ChangePasswordSuccessState()),
    );
  }
}
