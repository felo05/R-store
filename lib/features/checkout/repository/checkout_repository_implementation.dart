import 'package:dio/dio.dart';
import 'package:e_commerce/core/constants/kapi.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/dio_helper.dart';
import '../../cart/cubit/get_cart/cart_cubit.dart';
import 'checkout_repository.dart';

class CheckoutRepositoryImplementation implements CheckoutRepository {
  @override
  Future<Failure?> checkout(
      {required int paymentMethod,
      required int addressId,
      required BuildContext context}) async {
    try {
      final response=await DioHelpers.postData(path: Kapi.orders, body: {
        "address_id": addressId,
        "payment_method": paymentMethod,
        "use_points": false,
        "promo_code_id": null
      });
      if(response.data["status"] == false) return (ServerFailure(response.data["message"]));

      context.read<CartCubit>().getCart(context);
      return null;
    } catch (e) {
      if (e is DioException) return ServerFailure.fromDioError(e,context);
      return ServerFailure(e.toString());
    }
  }
}
