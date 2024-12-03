import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/authentication_repository_implementation.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static bool clickable = true;

  void register(
      {required String name,
      required String password,
      required String email,
      required String phoneNum, required BuildContext context}) async {
    final AuthenticationRepositoryImplementation registerRepo =
        AuthenticationRepositoryImplementation();

    clickable = false;
    emit(RegisterLoadingState());
    (await registerRepo.register(
            name: name, password: password, email: email, phoneNum: phoneNum,context: context))
        .fold((failure) {
      clickable = true;

      emit(RegisterErrorState(failure.errorMessage.toString()));
    }, (profile) {
      registerRepo.saveProfileDataLocally(profile.data!);
      clickable = true;
      emit(RegisterSuccessState());
    });
  }
}
