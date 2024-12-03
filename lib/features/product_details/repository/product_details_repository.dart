import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/material.dart';

import '../../home/models/products_model.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductsModel>> getProducts(BuildContext context);

  Future<Failure?> addToCart(
    int productId,
    int? quantity,
    BuildContext context,
  );
}
