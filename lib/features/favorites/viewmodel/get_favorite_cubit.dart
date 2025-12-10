import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:e_commerce/features/favorites/repository/i_favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_favorite_state.dart';

class GetFavoriteCubit extends Cubit<GetFavoriteState> {
  final IFavoritesRepository favoritesRepository;

  GetFavoriteCubit(this.favoritesRepository) : super(GetFavoriteInitial());

  Future<void> getFavorites(BuildContext context) async {
    emit(GetFavoriteLoadingState());
    (await favoritesRepository.getFavorites(context)).fold((failure) {
      emit(GetFavoriteErrorState(failure.toString()));
    }, (data) {
      emit(GetFavoriteSuccessState(data));
    });
  }
}
