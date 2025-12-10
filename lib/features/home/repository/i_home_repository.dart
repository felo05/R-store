import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/categories_model.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';

import '../models/banner_model.dart';

abstract class IHomeRepository {
  Future<Either<String, BannerModel>> getBanners(BuildContext context);
  Future<Either<String, CategoriesModel>> getCategories(BuildContext context);
  Future<Either<String,BaseProductData>> getProducts(BuildContext context);
  Future<Either<String, ProductData>> getAProduct(
      int productID, BuildContext context);
}

