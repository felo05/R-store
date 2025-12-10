import 'package:e_commerce/features/category_products/repository/i_category_products_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/models/products_model.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final ICategoryProductsRepository categoryProductsRepository;

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
