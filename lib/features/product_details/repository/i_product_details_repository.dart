import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';


abstract class IProductDetailsRepository {
  Future<Either<String, ProductsModel>> getProducts(BuildContext context);

  Future<Either<String, ProductData>> getProduct(int productId, BuildContext context);

  Future<Either<String, Unit>> addToCart(
    String productId,
    int? quantity,
    BuildContext context,
  );

  Future<Either<String, Unit>> deleteFromCart(
    String productId,
    BuildContext context,
  );
}

