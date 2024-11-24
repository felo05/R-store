import 'package:e_commerce/favorites/model/favorite_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../constants/kapi.dart';
import '../../helpers/dio_helper.dart';

part 'get_favorite_state.dart';

class GetFavoriteCubit extends Cubit<GetFavoriteState> {
  GetFavoriteCubit() : super(GetFavoriteInitial());
  FavoriteModel favoriteModel = FavoriteModel();

  void getFavorites() async {
    emit(GetFavoriteLoadingState());
    try {
      final response = await DioHelpers.getData(path: Kapi.favorites);
      favoriteModel = FavoriteModel.fromJson(response.data);

      if (favoriteModel.status ?? false) {
        emit(GetFavoriteSuccessState());
      } else {
        emit(GetFavoriteErrorState(favoriteModel.message ?? "Error"));
      }
    } catch (e) {
      emit(GetFavoriteErrorState(e.toString()));
    }
  }
}
