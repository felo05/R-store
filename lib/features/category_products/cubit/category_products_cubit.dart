import 'package:e_commerce/features/category_products/repository/category_products_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/models/products_model.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  CategoryProductsCubit() : super(CategoryProductsInitial());

  void getProductsByCategory(int categoryId, BuildContext context) async {
    emit(CategoryProductsLoadingState());
    (await CategoryProductsRepositoryImplementation()
            .getCategoryProducts(categoryId, context))
        .fold((failure) {
      emit(CategoryProductsErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(CategoryProductsSuccessState(data));
    });
  }
}
