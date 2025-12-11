class PrototypeProductsModel {
  PrototypeProductsModel({
    this.status,
    this.message,
    this.data,
  });

  PrototypeProductsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? BasePrototypeProductData.fromJson(json['data']) : null;
  }
  bool? status;
  dynamic message;
  BasePrototypeProductData? data;
}

class BasePrototypeProductData {
  BasePrototypeProductData({
    this.data,
    this.lastDocument,
  });

  BasePrototypeProductData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PrototypeProductData.fromJson(v));
      });
    }
    lastDocument = json['lastDocument'];
  }
  List<PrototypeProductData>? data;
  dynamic lastDocument; // For pagination
}


class PrototypeProductData {
  PrototypeProductData({
    this.id,
    this.price,
    this.oldPrice,
    this.discount,
    this.image,
    this.name,
  });

  PrototypeProductData.fromJson(dynamic json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
  }
  String? id; // Changed to dynamic to support both num and String (Firestore document ID)
  num? price;
  num? oldPrice;
  num? discount;
  String? image;
  String? name;
}