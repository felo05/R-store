import 'package:e_commerce/features/search/repository/search_repository_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/models/products_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void searchProduct(String query, BuildContext context) async {
    emit(SearchLoadingState());
    (await SearchRepositoryImplementation().search(query,context)).fold((failure) {
      emit(SearchErrorState(failure.errorMessage.toString()));
    }, (data) {
      emit(SearchSuccessState(data));
    });
  }
}
