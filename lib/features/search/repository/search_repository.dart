import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchRepository {
  Future<Either<Failure,BaseProductData>> search(String query,BuildContext context);
}