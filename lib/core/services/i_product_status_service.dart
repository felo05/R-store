import 'package:dartz/dartz.dart';

abstract class IProductStatusService {
  Map<String, Set<String>> getUserProductStatus();
  Map<String, bool> checkProductStatus(String productId);
  List<Map<String, dynamic>> applyStatusToProducts(
      List<Map<String, dynamic>> products,
      );
  void addProductToFavorites(String id);
  void addProductToCart(String id);
  void removeProductFromFavorites(String id);
  void removeProductFromCart(String id);
  bool isInFavorite(String productId);
  bool isInCart(String productId);
  void clearCart();
  Future<Either<String,Map<String, Set<String>>>> fetchFavoritesAndCart();

}