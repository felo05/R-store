import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/models/products_model.dart';
import '../../repository/i_categories_repository.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final ICategoriesRepository categoryProductsRepository;

  CategoryProductsCubit(this.categoryProductsRepository) : super(CategoryProductsInitial());

  void getProductsByCategory(int categoryId, BuildContext context) async {
    emit(CategoryProductsLoadingState());
    (await categoryProductsRepository
            .getCategoryProducts(categoryId, context))
        .fold((failure) {
      emit(CategoryProductsErrorState(failure.toString()));
    }, (data) {
      emit(CategoryProductsSuccessState(data));
    });
  }
}
