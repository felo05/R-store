import 'package:e_commerce/features/home/models/banner_model.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final IHomeRepository homeRepository;

  BannerCubit(this.homeRepository) : super(BannerInitial());

  void getBanners(BuildContext context) async {
    emit(BannerLoadingState());

    BannerModel bannerModel = BannerModel();
    (await homeRepository.getBanners(context)).fold((failure) {
      emit(BannerErrorState(failure.toString()));
    }, (data) {
      bannerModel = data;
      emit(BannerSuccessState(bannerModel));
    });
  }
}
