import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:e_commerce/features/favorites/repository/i_favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_favorite_state.dart';

class GetFavoriteCubit extends Cubit<GetFavoriteState> {
  final IFavoritesRepository favoritesRepository;
  static const int itemsPerPage = 15;

  GetFavoriteCubit(this.favoritesRepository) : super(GetFavoriteInitial());

  Future<void> getFavorites(BuildContext context) async {
    emit(GetFavoriteLoadingState());
    (await favoritesRepository.getFavorites(context, limit: itemsPerPage)).fold((failure) {
      emit(GetFavoriteErrorState(failure.toString()));
    }, (data) {
      emit(GetFavoriteSuccessState(data));
    });
  }

  Future<void> loadMoreFavorites(BuildContext context, FavoriteModel currentData) async {
    if (currentData.data?.lastDocument == null) return;

    emit(GetFavoriteLoadingMoreState(currentData));

    (await favoritesRepository.getFavorites(
      context,
      limit: itemsPerPage,
      lastDocument: currentData.data!.lastDocument
    )).fold((failure) {
      emit(GetFavoriteSuccessState(currentData)); // Keep current data on error
    }, (newData) {
      // Merge old and new data
      final List<FavoriteData> allFavorites = [
        ...(currentData.data?.data ?? <FavoriteData>[]),
        ...(newData.data?.data ?? <FavoriteData>[]),
      ];

      final mergedModel = FavoriteModel(
        status: newData.status,
        message: newData.message,
        data: FavoriteDataList(
          data: allFavorites,
          lastDocument: newData.data?.lastDocument,
        ),
      );

      emit(GetFavoriteSuccessState(mergedModel));
    });
  }
}
