part of 'get_favorite_cubit.dart';

@immutable
sealed class GetFavoriteState {}

final class GetFavoriteInitial extends GetFavoriteState {}

final class GetFavoriteLoadingState extends GetFavoriteState {}

final class GetFavoriteErrorState extends GetFavoriteState {
  final String msg;

  GetFavoriteErrorState(this.msg);
}

final class GetFavoriteSuccessState extends GetFavoriteState {}

final class GetFavoriteTokenExpireState extends GetFavoriteState {}