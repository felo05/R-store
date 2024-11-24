import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/helpers/hive_helper.dart';
import 'package:e_commerce/login/model/profile_model.dart';
import 'package:e_commerce/home/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  ProfileModel profileData =ProfileModel();
  void login({required String email,required String password})
  async{
    try {
      emit(LoginLoadingState());
      final response=await DioHelpers.postData(path: Kapi.login,body: {
        "email": email,
        "password": password
      });
       profileData=ProfileModel.fromJson(response.data);
       if(response.data["status"]??false){
         HiveHelper.setToken(profileData.data!.token!);
         HiveHelper.setUser(profileData.data!);
         Get.offAll(() =>   MainScreen(selectedIndex: 0,));
         emit(LoginSuccessState());

       }else{
         emit(LoginErrorState(response.data["message"]??"Error"));

       }
    }catch(e){
      emit(LoginErrorState(e.toString()));

    }



  }
}
