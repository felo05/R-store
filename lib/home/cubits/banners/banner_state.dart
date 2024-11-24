part of 'banner_cubit.dart';

@immutable
sealed class BannerState {}

final class BannerInitial extends BannerState {}

final class BannerLoadingState extends BannerState {}

final class BannerErrorState extends BannerState {
  final String errorMsg;
  BannerErrorState(this.errorMsg);
}

final class BannerSuccessState extends BannerState {}
