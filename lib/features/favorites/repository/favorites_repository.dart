import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/material.dart';

import '../model/favorite_model.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, FavoriteModel>> getFavorites(BuildContext context);

  void addFavorite(
      String productID, BuildContext context, bool? isInHomeScreen, bool reloadAllRelatedData);
}
