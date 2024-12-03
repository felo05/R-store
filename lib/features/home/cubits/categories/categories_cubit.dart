import 'package:e_commerce/features/home/repository/home_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/categories_model.dart';
part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  void getCategories(BuildContext context) async {
    emit(CategoriesLoadingState());
    (await HomeRepositoryImplementation().getCategories(context)).fold(
        (failure) {
      emit(CategoriesErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(CategoriesSuccessState(data));
    });
  }
}
