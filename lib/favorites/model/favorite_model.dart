import 'package:e_commerce/home/models/products_model.dart';

class FavoriteModel {
  bool? status;
  String? message;
  BaseData? data;

  FavoriteModel({this.status, this.message, this.data});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? BaseData.fromJson(json['data']) : null;
  }
}

class BaseData {
  List<FavoriteData>? data;


  BaseData({
    this.data,

  });

  BaseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(FavoriteData.fromJson(v));
      });
    }
  }
}

class FavoriteData {
  int? id;
  ProductData? product;

  FavoriteData({this.id, this.product});

  FavoriteData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? ProductData.fromJson(json['product']) : null;
  }
}
