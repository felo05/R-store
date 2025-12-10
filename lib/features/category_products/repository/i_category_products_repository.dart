import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

abstract class ICategoryProductsRepository {
  Future<Either<String, List<ProductData>>> getCategoryProducts(int categoryId,BuildContext context);
}

