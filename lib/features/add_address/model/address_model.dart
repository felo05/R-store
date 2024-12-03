class AddressModel {
  AddressModel({
    this.status,
    this.message,
    this.baseData,
  });

  AddressModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    baseData = json['data'] != null ? BaseData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  BaseData? baseData;
}

class BaseData {
  BaseData({
    this.addressData,
  });

  BaseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      addressData = [];
      json['data'].forEach((v) {
        addressData?.add(AddressData.fromJson(v));
      });
    }
  }

  List<AddressData>? addressData;
}

class AddressData {
  AddressData({
    this.id,
    this.name,
    this.city,
    this.region,
    this.details,
    this.notes,
    this.latitude,
    this.longitude,
  });

  AddressData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    region = json['region'];
    details = json['details'];
    notes = json['notes'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  int? id;
  String? name;
  String? city;
  String? region;
  String? details;
  String? notes;
  double? latitude;
  double? longitude;
}
