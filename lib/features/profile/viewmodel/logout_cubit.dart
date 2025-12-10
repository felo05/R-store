import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/i_logout_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final ILogoutRepository logoutRepository;

  LogoutCubit(this.logoutRepository) : super(LogoutInitial());

  void logout(BuildContext context) async {
    emit(LogoutLoadingState());
    final result=await logoutRepository.logout(context);
    result.fold(
          (failure) => emit(LogoutErrorState(failure)),
          (_) {
        logoutRepository.removeProfileDataLocally();
        emit(LogoutSuccessState());
      },
    );
  }
}
