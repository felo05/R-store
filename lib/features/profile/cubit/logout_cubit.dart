import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/logout_repository_implementation.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  void logout(BuildContext context) async {
    emit(LogoutLoadingState());
    LogoutRepositoryImplementation logoutRepo =
        LogoutRepositoryImplementation();
    await logoutRepo.logout(context).then((failure) {
      if (failure == null) {
        logoutRepo.removeProfileDataLocally();
        emit(LogoutSuccessState());
      } else {
        emit(LogoutErrorState(failure.errorMessage.toString()));
      }
    });
  }
}
