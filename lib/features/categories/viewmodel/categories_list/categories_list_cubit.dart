import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/features/home/models/categories_model.dart';
import '../../repository/i_categories_repository.dart';

part 'categories_list_state.dart';

class CategoriesListCubit extends Cubit<CategoriesListState> {
  final ICategoriesRepository categoriesRepository;
  static const int itemsPerPage = 10;

  CategoriesListCubit(this.categoriesRepository) : super(CategoriesListInitial());

  Future<void> getCategories(BuildContext context) async {
    emit(CategoriesListLoadingState());
    (await categoriesRepository.getCategories(context, limit: itemsPerPage)).fold(
      (failure) {
        emit(CategoriesListErrorState(failure.toString()));
      },
      (response) {
        emit(CategoriesListSuccessState(
          response.categories ?? <CategoriesData>[],
          response.lastDocument,
        ));
      },
    );
  }

  Future<void> loadMoreCategories(
      BuildContext context, List<CategoriesData> currentCategories, dynamic lastDocument) async {
    if (lastDocument == null) return;

    emit(CategoriesListLoadingMoreState(currentCategories));

    (await categoriesRepository.getCategories(
      context,
      limit: itemsPerPage,
      lastDocument: lastDocument,
    )).fold(
      (failure) {
        emit(CategoriesListSuccessState(currentCategories, lastDocument)); // Keep current data on error
      },
      (response) {
        final List<CategoriesData> allCategories = [
          ...currentCategories,
          ...(response.categories ?? <CategoriesData>[])
        ];
        emit(CategoriesListSuccessState(allCategories, response.lastDocument));
      },
    );
  }
}
