import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  void changePassword(String oldPassword, String newPassword) async{
    try{
      emit(ChangePasswordLoadingState());
      final response = await DioHelpers.postData(path: Kapi.changePassword,body: {
        "current_password": oldPassword,
        "new_password": newPassword,
      });
      if(response.data['status']){
        emit(ChangePasswordSuccessState());}
      else{
        emit(ChangePasswordErrorState(response.data['message']));
      }
    }catch(e){
      emit(ChangePasswordErrorState(e.toString()));
    }
  }
}
