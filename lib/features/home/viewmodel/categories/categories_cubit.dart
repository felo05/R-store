import 'package:e_commerce/features/home/repository/i_home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/home/models/categories_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final IHomeRepository homeRepository;

  CategoriesCubit(this.homeRepository) : super(CategoriesInitial());

  void getCategories(BuildContext context) async {
    emit(CategoriesLoadingState());
    (await homeRepository.getCategories(context)).fold(
        (failure) {
      emit(CategoriesErrorState(failure.toString()));
    }, (data) {
      emit(CategoriesSuccessState(data));
    });
  }
}
