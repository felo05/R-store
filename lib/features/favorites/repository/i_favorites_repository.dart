import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../model/favorite_model.dart';

abstract class IFavoritesRepository {
  Future<Either<String, FavoriteModel>> getFavorites(BuildContext context);

  void addFavorite(
      String productID, BuildContext context, bool? isInHomeScreen, bool reloadAllRelatedData);
}