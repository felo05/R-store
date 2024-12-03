import 'package:e_commerce/features/product_details/repository/product_details_repository_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/models/products_model.dart';

part 'products_in_details_state.dart';

class ProductsInDetailsCubit extends Cubit<ProductsInDetailsState> {
  ProductsInDetailsCubit() : super(ProductsInDetailsInitial());

  void getProducts(BuildContext context) async {
    emit(ProductsInDetailsLoadingState());

    (await ProductDetailsRepositoryImplementation().getProducts(context)).fold(
        (failure) {
      emit(ProductsInDetailsErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(ProductsInDetailsSuccessState(data));
    });
  }
}
