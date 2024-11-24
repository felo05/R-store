import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/home/models/products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void searchProduct(String query) async {
    emit(SearchLoadingState());
    try {
      final response = await DioHelpers.postData(path: Kapi.search, body: {
        'text': query,
      });
      List<ProductData> products = [];
      response.data["data"]["data"].forEach((v) {
        products.add(ProductData.fromJson(v));
      });
      emit(SearchSuccessState(products));
    } catch (e) {
      emit(SearchErrorState(e.toString()));
    }
  }
}
