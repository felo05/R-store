import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

import '../model/cart_model.dart';

abstract class CartRepository {
  Future<Either<Failure, CartResponse>> getCartProducts(BuildContext context);
}
