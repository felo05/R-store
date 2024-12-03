import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';
import '../../../core/errors/api_errors.dart';

abstract class CategoryProductsRepository {
  Future<Either<Failure, List<ProductData>>> getCategoryProducts(int categoryId,BuildContext context);
}