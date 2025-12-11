import '../../home/models/prototype_products_model.dart';

class CartResponse {
  final bool? status;
  final String? message;
  final CartData? data;

  CartResponse({ this.status, this.message,  this.data});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      status: json['status'],
      message: json['message'],
      data: CartData.fromJson(json['data']),
    );
  }
}

class CartData {
  final List<CartItem>? cartItems;
  final num? total;

  CartData({ this.cartItems,    this.total});

  factory CartData.fromJson(Map<String, dynamic> json) {
    var cartItemsJson = json['cart_items'] as List;
    List<CartItem> cartItems = cartItemsJson.map((item) => CartItem.fromJson(item)).toList();

    return CartData(
      cartItems: cartItems,
      total: json['total'],
    );
  }
}

class CartItem {
  final String id;
  final int quantity;
  final PrototypeProductData product;

  CartItem({required this.id, required this.quantity, required this.product});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      product: PrototypeProductData.fromJson(json['product']),
    );
  }
}
