import 'package:e_commerce/features/home/models/banner_model.dart';
import 'package:e_commerce/features/home/repository/home_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerInitial());

  void getBanners(BuildContext context) async {
    emit(BannerLoadingState());

    BannerModel bannerModel = BannerModel();
    (await HomeRepositoryImplementation().getBanners(context)).fold((failure) {
      emit(BannerErrorState(failure.errorMessage.toString()));
    }, (data) {
      bannerModel = data;
      emit(BannerSuccessState(bannerModel));
    });
  }
}
