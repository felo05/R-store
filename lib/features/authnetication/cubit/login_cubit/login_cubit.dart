import 'package:e_commerce/features/authnetication/repository/authentication_repository_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login({required String email, required String password, required BuildContext context}) async {
    final AuthenticationRepositoryImplementation loginRepo =
        AuthenticationRepositoryImplementation();

    emit(LoginLoadingState());
    (await loginRepo.login(email, password,context)).fold((failure) {
      emit(LoginErrorState(failure.errorMessage.toString()));
    }, (profile) {
      loginRepo.saveProfileDataLocally(profile.data!);
      emit(LoginSuccessState());
    });
  }
}
