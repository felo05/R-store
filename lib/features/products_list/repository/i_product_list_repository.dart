import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../model/products_list_model.dart';

abstract class IProductsListRepository {
  Future<Either<String, ProductsListResponse>> getProducts(
      BuildContext context, {int? limit, dynamic lastDocument});
}

