import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/helpers/hive_helper.dart';
import 'package:e_commerce/login/model/profile_model.dart';
import 'package:e_commerce/profile/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/kapi.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  void updateProfile(String name, String email, String phone) async {
    try {
      emit(EditProfileLoadingState());
      final response = await DioHelpers.putData(
          path: Kapi.updateProfile,
          body: {
            'name': name,
            'email': email,
            'phone': phone,
            'image': null,

          });
      if (response.data['status'] == true) {
        HiveHelper.setUser(ProfileData(name: name, email: email, phone: phone, image: "https://student.valuxapps.com/storage/assets/defaults/user.jpg"));
        ProfileScreen.user = HiveHelper.getUser() ?? ProfileData();
        emit(EditProfileSuccessState());
      } else {
        emit(EditProfileErrorState(response.data['message']));
      }
    } catch (e) {
      emit(EditProfileErrorState(e.toString()));
    }
  }
}
