import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../model/cart_model.dart';

abstract class ICartRepository {
  Future<Either<String, CartResponse>> getCartProducts(BuildContext context);
  void changeQuantityCloudly({required int quantity, required String productId});
}

