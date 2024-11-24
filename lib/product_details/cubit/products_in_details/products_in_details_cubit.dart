import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../constants/kapi.dart';
import '../../../helpers/dio_helper.dart';
import '../../../home/models/products_model.dart';

part 'products_in_details_state.dart';

class ProductsInDetailsCubit extends Cubit<ProductsInDetailsState> {
  ProductsInDetailsCubit() : super(ProductsInDetailsInitial());
  ProductsModel productsModel = ProductsModel();

  void getProducts() async {
    try {
      emit(ProductsInDetailsLoadingState());
      final response = await DioHelpers.getData(path: Kapi.products);
      productsModel = ProductsModel.fromJson(response.data);
      if (productsModel.status ?? false) {
        emit(ProductsInDetailsSuccessState());
      } else {
        emit(ProductsInDetailsErrorState(productsModel.message ?? "Error"));
      }
    } catch (e) {
      emit(ProductsInDetailsErrorState(e.toString()));
    }
  }
}
