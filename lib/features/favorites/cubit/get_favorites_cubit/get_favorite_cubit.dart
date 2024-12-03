import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:e_commerce/features/favorites/repository/favorites_repository_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_favorite_state.dart';

class GetFavoriteCubit extends Cubit<GetFavoriteState> {
  GetFavoriteCubit() : super(GetFavoriteInitial());

  Future<void> getFavorites(BuildContext context) async {
    emit(GetFavoriteLoadingState());
    (await FavoritesRepositoryImplementation().getFavorites(context)).fold((failure) {
      emit(GetFavoriteErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(GetFavoriteSuccessState(data));
    });
  }
}
