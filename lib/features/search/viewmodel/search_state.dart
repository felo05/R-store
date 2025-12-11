part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchErrorState extends SearchState {
  SearchErrorState(this.error);

  final String error;
}

final class SearchLoadingState extends SearchState {}

final class SearchLoadingMoreState extends SearchState {
  SearchLoadingMoreState(this.currentProducts);

  final BasePrototypeProductData currentProducts;
}

final class SearchSuccessState extends SearchState {
  SearchSuccessState(this.products, this.query);

  final BasePrototypeProductData products;
  final String query; // Keep track of current search query
}
