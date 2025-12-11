import 'package:e_commerce/features/search/repository/i_search_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/home/models/products_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ISearchRepository searchRepository;
  static const int itemsPerPage = 15;

  SearchCubit(this.searchRepository) : super(SearchInitial());

  void searchProduct(String query, BuildContext context) async {
    emit(SearchLoadingState());
    (await searchRepository.search(query, context, limit: itemsPerPage)).fold((failure) {
      emit(SearchErrorState(failure.toString()));
    }, (data) {
      emit(SearchSuccessState(data, query));
    });
  }

  Future<void> loadMoreSearchResults(String query, BuildContext context, BaseProductData currentData) async {
    if (currentData.lastDocument == null) return;

    emit(SearchLoadingMoreState(currentData));

    (await searchRepository.search(query, context, limit: itemsPerPage, lastDocument: currentData.lastDocument)).fold(
      (failure) {
        emit(SearchSuccessState(currentData, query)); // Keep current data on error
      },
      (newData) {
        final List<ProductData> allProducts = [...(currentData.data ?? <ProductData>[]), ...(newData.data ?? <ProductData>[])];
        final mergedData = BaseProductData(
          data: allProducts,
          lastDocument: newData.lastDocument,
        );
        emit(SearchSuccessState(mergedData, query));
      }
    );
  }
}
