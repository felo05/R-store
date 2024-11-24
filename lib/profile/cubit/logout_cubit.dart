import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/helpers/hive_helper.dart';
import 'package:e_commerce/login/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

import '../../constants/kapi.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  void logout() async {
    emit(LogoutLoadingState());
    try {
       await DioHelpers.postData(
          path: Kapi.logout, body: {"fcm_token": "SomeFcmToken"});
       HiveHelper.removeToken();
       emit(LogoutSuccessState());
       Get.offAll(LoginScreen());

    } catch (e) {
      emit(LogoutErrorState(e.toString()));
    }
  }
}
