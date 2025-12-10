import 'package:e_commerce/features/authnetication/repository/i_authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.iAuthenticationRepository) : super(LoginInitial());
  final IAuthenticationRepository iAuthenticationRepository;

  void login({required String email, required String password, required BuildContext context}) async {

    emit(LoginLoadingState());
    (await iAuthenticationRepository.login(email, password,context)).fold((failure) {
      emit(LoginErrorState(failure.toString()));
    }, (profile) {
      iAuthenticationRepository.saveProfileDataLocally(profile.data!);
      emit(LoginSuccessState());
    });
  }
}
