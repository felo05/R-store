import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:flutter/material.dart';

abstract class ICategoriesRepository {
  Future<Either<String, List<ProductData>>> getCategoryProducts(int categoryId, BuildContext context);
  Future<Either<String, CategoriesResponse>> getCategories(BuildContext context, {int? limit, dynamic lastDocument});
}

