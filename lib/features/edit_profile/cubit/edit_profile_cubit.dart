import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/edit_profile_repository_implementation.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  void updateProfile(
      String name, String email, String phone, BuildContext context) async {
    emit(EditProfileLoadingState());
    EditProfileRepositoryImplementation editProfileRepo =
        EditProfileRepositoryImplementation();
    await editProfileRepo
        .updateProfile(name, email, phone, context)
        .then((failure) {
      if (failure == null) {
        editProfileRepo.updateLocaleProfileData(name, email, phone);
        emit(EditProfileSuccessState());
      } else {
        emit(EditProfileErrorState(failure.errorMessage.toString()));
      }
    });
  }
}
