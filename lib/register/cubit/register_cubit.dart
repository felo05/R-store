import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/helpers/hive_helper.dart';
import 'package:e_commerce/login/model/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../home/main_screen.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  ProfileModel _registerModel = ProfileModel();
  static bool clickable=true;
  void register(
      {required String name,
      required String password,
      required String email,
      required String phoneNum}) async {
    try {
      clickable=false;
      emit(RegisterLoadingState());
      final response = await DioHelpers.postData(path: Kapi.register, body: {
        "name": name,
        "phone": phoneNum,
        "email": email,
        "password": password,
        "image": null
      });
      _registerModel = ProfileModel.fromJson(response.data);

      if (_registerModel.status ?? false) {
        HiveHelper.setToken(_registerModel.data!.token!);
        HiveHelper.setUser(_registerModel.data!);
        Get.offAll(() =>   MainScreen(selectedIndex: 0,));
        emit(RegisterSuccessState());
      } else {
        emit(RegisterErrorState(_registerModel.message ?? "Error"));
        clickable=true;
      }
    } catch (e) {
      emit(RegisterErrorState(e.toString()));
      clickable=true;
    }
  }
}
