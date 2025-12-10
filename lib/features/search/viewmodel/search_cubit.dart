import 'package:e_commerce/features/search/repository/i_search_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/home/models/products_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ISearchRepository searchRepository;

  SearchCubit(this.searchRepository) : super(SearchInitial());

  void searchProduct(String query, BuildContext context) async {
    emit(SearchLoadingState());
    (await searchRepository.search(query,context)).fold((failure) {
      emit(SearchErrorState(failure.toString()));
    }, (data) {
      emit(SearchSuccessState(data));
    });
  }
}
