import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductsModel>> getProducts(BuildContext context);

  Future<Failure?> addToCart(
    String productId,
    int? quantity,
    BuildContext context,
  );

  Future<Failure?> deleteFromCart(
    String productId,
    BuildContext context,
  );
}
