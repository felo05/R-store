import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final IHomeRepository homeRepository;

  ProductsCubit(this.homeRepository) : super(ProductsInitial());

  Future<void> getProducts(BuildContext context) async {
    emit(ProductsLoadingState());
    (await homeRepository.getProducts(context)).fold((failure) {
      emit(ProductsErrorState(failure.toString()));
    }, (data) {
      emit(ProductsSuccessState(data));
    });
  }

   Future<Either<String, ProductData>> getAProduct(
      int productID, BuildContext context) async {
return await homeRepository.getAProduct(productID, context);
  }
}
