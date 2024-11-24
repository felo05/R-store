part of 'add_favorite_cubit.dart';

@immutable
sealed class AddFavoriteState {}

final class AddFavoriteInitial extends AddFavoriteState {}

final class AddFavoriteErrorState extends AddFavoriteState {
  final String msg;

  AddFavoriteErrorState(this.msg);
}

final class AddFavoriteSuccessState extends AddFavoriteState {}

final class AddFavoriteLoadingState extends AddFavoriteState {}