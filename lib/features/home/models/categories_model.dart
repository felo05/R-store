class CategoriesModel {
  CategoriesModel({
    this.status,
    this.message,
    this.data,
  });

  CategoriesModel.fromJson(dynamic json) {
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
        data?.add(CategoriesData.fromJson(v));
      });
    }
  }

  List<CategoriesData>? data;
}

class CategoriesData {
  CategoriesData({
    this.id,
    this.name,
    this.image,
  });

  CategoriesData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  num? id;
  String? name;
  String? image;
}
