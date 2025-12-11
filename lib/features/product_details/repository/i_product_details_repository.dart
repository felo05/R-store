import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/prototype_products_model.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';


abstract class IProductDetailsRepository {
  Future<Either<String, PrototypeProductsModel>> getProducts(BuildContext context);

  Future<Either<String, ProductData>> getProduct(String productId, BuildContext context);

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

