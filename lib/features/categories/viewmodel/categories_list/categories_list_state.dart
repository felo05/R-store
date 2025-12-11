part of 'categories_list_cubit.dart';

@immutable
sealed class CategoriesListState {}

final class CategoriesListInitial extends CategoriesListState {}

final class CategoriesListLoadingState extends CategoriesListState {}

final class CategoriesListLoadingMoreState extends CategoriesListState {
  final List<CategoriesData> currentCategories;

  CategoriesListLoadingMoreState(this.currentCategories);
}

final class CategoriesListErrorState extends CategoriesListState {
  final String error;

  CategoriesListErrorState(this.error);
}

final class CategoriesListSuccessState extends CategoriesListState {
  final List<CategoriesData> categories;
  final dynamic lastDocument;

  CategoriesListSuccessState(this.categories, this.lastDocument);
}

