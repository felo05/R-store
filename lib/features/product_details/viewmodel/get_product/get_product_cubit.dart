import 'package:e_commerce/features/product_details/repository/i_product_details_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/home/models/products_model.dart';

part 'get_product_state.dart';

class GetProductCubit extends Cubit<GetProductState> {
  final IProductDetailsRepository productDetailsRepository;

  GetProductCubit(this.productDetailsRepository) : super(GetProductInitial());

  Future<void> getProduct(int productId, BuildContext context) async {
    emit(GetProductLoadingState());

    final result = await productDetailsRepository.getProduct(productId, context);

    result.fold(
      (failure) {
        emit(GetProductErrorState(failure));
      },
      (product) {
        emit(GetProductSuccessState(product));
      },
    );
  }
}
