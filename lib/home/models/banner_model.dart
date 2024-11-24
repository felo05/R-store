class BannerModel {
  bool? status;
  String? message;
  List<BannerData>? data;

  BannerModel({
    this.status,
    this.message,
    this.data,
  });

  BannerModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(BannerData.fromJson(v));
      });
    }
  }
}

class BannerData {
  BannerData({this.image});

  BannerData.fromJson(dynamic json) {
    image = json['image'];
  }

  String? image;
}
