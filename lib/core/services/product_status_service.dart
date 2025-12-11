import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';

import 'i_product_status_service.dart';

class ProductStatusService implements IProductStatusService {
   final Map<String, Set<String>> _result = {
    'favorites': <String>{},
    'cart': <String>{},
  };

   @override
  Future<Either<String,Map<String, Set<String>>>> fetchFavoritesAndCart() async {
    if (FirebaseConstants.currentUserId == null) {
      return left('User not logged in');
    }
     final results = await Future.wait([
        FirebaseConstants.firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(FirebaseConstants.currentUserId)
            .collection(FirebaseConstants.favoritesCollection)
            .get(),
        FirebaseConstants.firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(FirebaseConstants.currentUserId)
            .collection(FirebaseConstants.cartCollection)
            .get(),
      ]);

      _result['favorites'] = results[0].docs.map((doc) => doc.id).toSet();
      _result['cart'] = results[1].docs.map((doc) => doc.id).toSet();
    return right(_result);
  }
  @override
  Map<String, Set<String>> getUserProductStatus() {
    return (_result);
  }

  /// Checks if a specific product is in favorites and/or cart
  /// Returns a map with 'inFavorites' and 'inCart' boolean flags
  @override
  Map<String, bool> checkProductStatus(String productId)  {

    return {
      'inFavorites': _result['favorites']!.contains(productId),
      'inCart': _result['cart']!.contains(productId)
    };
  }

  /// Applies product status flags to a list of product data maps
  /// This is useful when fetching multiple products
  @override
  List<Map<String, dynamic>> applyStatusToProducts(
    List<Map<String, dynamic>> products,
  ) {

    return products.map((product) {
      product['in_favorites'] = _result['favorites']!.contains(product['id']);
      product['in_cart'] = _result['cart']!.contains(product['id']);
      return product;
    }).toList();
  }

  @override
  void clearCart() {
    _result['cart']!.clear();
  }

  @override
  void addProductToCart(String id) {
    _result['cart']!.add(id);
  }

  @override
  void addProductToFavorites(String id) {
    _result['favorites']!.add(id);
  }

  @override
  void removeProductFromCart(String id) {

    _result['cart']!.remove(id);
  }

  @override
  void removeProductFromFavorites(String id) {
    _result['favorites']!.remove(id);
  }

  @override
  bool isInFavorite(String productId) {

    return _result['favorites']!.contains(productId);
  }

  @override
  bool isInCart(String productId) {

    return _result['cart']!.contains(productId);
  }
}

