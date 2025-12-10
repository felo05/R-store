import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/i_authentication_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.iAuthenticationRepository) : super(RegisterInitial());
  static bool clickable = true;
  final IAuthenticationRepository iAuthenticationRepository;

  void register(
      {required String name,
      required String password,
      required String email,
      required String phoneNum, required BuildContext context}) async {

    clickable = false;
    emit(RegisterLoadingState());
    (await iAuthenticationRepository.register(
            name: name, password: password, email: email, phoneNum: phoneNum,context: context))
        .fold((failure) {
      clickable = true;

      emit(RegisterErrorState(failure.toString()));
    }, (profile) {
      iAuthenticationRepository.saveProfileDataLocally(profile.data!);
      clickable = true;
      emit(RegisterSuccessState());
    });
  }
}
