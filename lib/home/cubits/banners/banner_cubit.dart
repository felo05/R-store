import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/home/models/banner_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../helpers/dio_helper.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerInitial());
  BannerModel bannerModel=BannerModel();
  void getBanners()
  async{
    try {
      emit(BannerLoadingState());
      final response=await DioHelpers.getData(path: Kapi.banners);
      bannerModel=BannerModel.fromJson(response.data);
      if(bannerModel.status??false){
        emit(BannerSuccessState());

      }else{
        emit(BannerErrorState(bannerModel.message??"Error"));
      }
    }catch(e){
      emit(BannerErrorState(e.toString()));
    }



  }
}
