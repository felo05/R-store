import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/kapi.dart';
import '../../helpers/dio_helper.dart';
import '../../home/models/products_model.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  CategoryProductsCubit() : super(CategoryProductsInitial());

    void getProductsByCategory(int categoryID) async{
      try {
        emit(CategoryProductsLoadingState());
        final response = await DioHelpers.getData(path: "${Kapi.categories}/$categoryID");
         List<ProductData> productData=[];
        response.data["data"]['data'].forEach((v) {
          productData.add(ProductData.fromJson(v));
        });
        if (response.data["status"] ?? false) {
          emit(CategoryProductsSuccessState(productData));
        } else {
          emit(CategoryProductsErrorState(response.data["message"] ?? "Error"));
        }
      } catch (e) {
        emit(CategoryProductsErrorState(e.toString()));
      }
    }
}
