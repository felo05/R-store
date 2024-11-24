import 'package:e_commerce/home/models/products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../constants/kapi.dart';
import '../../../helpers/dio_helper.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  ProductsModel productsModel = ProductsModel();

  void getProducts() async {
    try {
      emit(ProductsLoadingState());
      final response = await DioHelpers.getData(path: Kapi.products);
      productsModel = ProductsModel.fromJson(response.data);
      if (productsModel.status ?? false) {
        emit(ProductsSuccessState());
      } else {
        emit(ProductsErrorState(productsModel.message ?? "Error"));
      }
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
  }

  Future<ProductData> getAProduct(int productID) async {
    try {
      emit(ProductsLoadingState());
      final response =
          await DioHelpers.getData(path: '${Kapi.products}/$productID');
      if (response.data['status']) {
        emit(ProductsSuccessState());
        return ProductData.fromJson(response.data['data']);
      } else {
        emit(ProductsErrorState(response.data['message']));
      }
    } catch (e) {
      emit(ProductsErrorState(e.toString()));
    }
    return ProductData();
  }
}
