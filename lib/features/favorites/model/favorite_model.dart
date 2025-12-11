import 'package:e_commerce/features/home/models/prototype_products_model.dart';

class FavoriteModel {
  FavoriteModel({
    this.status,
    this.message,
    this.data,
  });

  FavoriteModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? FavoriteDataList.fromJson(json['data']) : null;
  }

  bool? status;
  dynamic message;
  FavoriteDataList? data;
}

class FavoriteDataList {
  FavoriteDataList({
    this.data,
    this.lastDocument,
  });

  FavoriteDataList.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FavoriteData.fromJson(v));
      });
    }
    lastDocument = json['lastDocument'];
  }

  List<FavoriteData>? data;
  dynamic lastDocument; // For pagination
}

class FavoriteData {
  FavoriteData({
    this.id,
    this.product,
  });

  FavoriteData.fromJson(dynamic json) {
    id = json['id'];
    product = json['product'] != null
        ? PrototypeProductData.fromJson(json['product'])
        : null;
  }

  String? id;
  PrototypeProductData? product;
}
