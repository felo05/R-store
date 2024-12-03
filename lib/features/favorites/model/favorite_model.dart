import 'package:e_commerce/features/home/models/products_model.dart';

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
  });

  FavoriteDataList.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FavoriteData.fromJson(v));
      });
    }
  }

  List<FavoriteData>? data;
}

class FavoriteData {
  FavoriteData({
    this.id,
    this.product,
  });

  FavoriteData.fromJson(dynamic json) {
    id = json['id'];
    product = json['product'] != null
        ? ProductData.fromJson(json['product'])
        : null;
  }

  num? id;
  ProductData? product;
}
