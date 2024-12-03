import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

import '../models/banner_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, BannerModel>> getBanners(BuildContext context);
  Future<Either<Failure, CategoriesModel>> getCategories(BuildContext context);
  Future<Either<Failure,BaseProductData>> getProducts(BuildContext context);
}
