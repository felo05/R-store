import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../constants/kapi.dart';
import '../../../helpers/dio_helper.dart';
import '../../models/categories_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());
  CategoriesModel categoriesModel = CategoriesModel();
  void getCategories() async {
    try {
      emit(CategoriesLoadingState());
      final response = await DioHelpers.getData(path: Kapi.categories);
      categoriesModel = CategoriesModel.fromJson(response.data);
      if (categoriesModel.status ?? false) {
        emit(CategoriesSuccessState());
      } else {
        emit(CategoriesErrorState(categoriesModel.message ?? "Error"));
      }

    } catch (e) {
      // Debugging errors
      emit(CategoriesErrorState(e.toString()));
    }
  }

}
