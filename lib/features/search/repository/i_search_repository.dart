import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/home/models/prototype_products_model.dart';
import 'package:flutter/cupertino.dart';


abstract class ISearchRepository {
  Future<Either<String,BasePrototypeProductData>> search(String query, BuildContext context, {int? limit, dynamic lastDocument});
}

