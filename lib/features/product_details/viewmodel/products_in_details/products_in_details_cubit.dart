import 'package:e_commerce/features/product_details/repository/i_product_details_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/home/models/products_model.dart';

part 'products_in_details_state.dart';

class ProductsInDetailsCubit extends Cubit<ProductsInDetailsState> {
  final IProductDetailsRepository productDetailsRepository;

  ProductsInDetailsCubit(this.productDetailsRepository) : super(ProductsInDetailsInitial());

  void getProducts(BuildContext context) async {
    emit(ProductsInDetailsLoadingState());

    (await productDetailsRepository.getProducts(context)).fold(
        (failure) {
      emit(ProductsInDetailsErrorState(failure.toString()));
    }, (data) {
      emit(ProductsInDetailsSuccessState(data));
    });
  }
}
