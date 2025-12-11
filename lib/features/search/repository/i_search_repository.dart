import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/cupertino.dart';


abstract class ISearchRepository {
  Future<Either<String,BaseProductData>> search(String query, BuildContext context, {int? limit, dynamic lastDocument});
}

