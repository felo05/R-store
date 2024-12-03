part of 'categories_cubit.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesErrorState extends CategoriesState {
  final String message;

  CategoriesErrorState(this.message);
}

final class CategoriesLoadingState extends CategoriesState {}

final class CategoriesSuccessState extends CategoriesState {
  final CategoriesModel categories;

  CategoriesSuccessState(this.categories);
}

