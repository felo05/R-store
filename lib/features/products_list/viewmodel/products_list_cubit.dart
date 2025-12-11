import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../home/models/products_model.dart';
import '../repository/i_product_list_repository.dart';

part 'products_list_state.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  ProductsListCubit(this._productsListRepository) : super(ProductsListInitial());

  final IProductsListRepository _productsListRepository;
  static const int itemsPerPage = 15;

  void getProducts(BuildContext context) async {
    emit(ProductsListLoadingState());

    (await _productsListRepository.getProducts(context, limit: itemsPerPage)).fold(
      (failure) {
        emit(ProductsListErrorState(failure.toString()));
      },
      (response) {
        emit(ProductsListSuccessState(response.products ?? [], response.lastDocument));
      }
    );
  }

  Future<void> loadMoreProducts(BuildContext context, List<ProductData> currentProducts, dynamic lastDocument) async {
    if (lastDocument == null) return;

    emit(ProductsListLoadingMoreState(currentProducts));

    (await _productsListRepository.getProducts(context, limit: itemsPerPage, lastDocument: lastDocument)).fold(
      (failure) {
        emit(ProductsListSuccessState(currentProducts, lastDocument)); // Keep current data on error
      },
      (response) {
        final List<ProductData> allProducts = [...currentProducts, ...(response.products ?? <ProductData>[])];
        emit(ProductsListSuccessState(allProducts, response.lastDocument));
      }
    );
  }
}
