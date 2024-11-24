class ProductsModel {
  ProductsModel({
    this.status,
    this.message,
    this.data,
  });

  ProductsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? BaseData.fromJson(json['data']) : null;
  }
  bool? status;
  dynamic message;
  BaseData? data;
}

class BaseData {
  BaseData({
    this.data,

  });

  BaseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductData.fromJson(v));
      });
    }

  }
  List<ProductData>? data;

}

class ProductData {
  ProductData({
    this.id,
    this.price,
    this.oldPrice,
    this.discount,
    this.image,
    this.name,
    this.description,
    this.images,
    this.inFavorites,
    this.inCart,
  });

  ProductData.fromJson(dynamic json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
  num? id;
  num? price;
  num? oldPrice;
  num? discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;
}