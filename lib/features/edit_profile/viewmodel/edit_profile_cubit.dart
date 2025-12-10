import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/i_edit_profile_repository.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final IEditProfileRepository editProfileRepository;

  EditProfileCubit(this.editProfileRepository) : super(EditProfileInitial());

  void updateProfile(
      String name, String email, String phone, BuildContext context) async {
    emit(EditProfileLoadingState());
    final result=await editProfileRepository
        .updateProfile(name, email, phone,context);
    result.fold(
          (failure) => emit(EditProfileErrorState(failure)),
          (_) => emit(EditProfileSuccessState()),
    );
  }
}
