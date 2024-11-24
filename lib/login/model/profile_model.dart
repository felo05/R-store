import 'package:hive/hive.dart';

part 'profile_model.g.dart';
class ProfileModel {
  ProfileModel({
      this.status, 
      this.message, 
      this.data,});

  ProfileModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }
  bool? status;
  dynamic message;
  ProfileData? data;



}
// For the generated adapter

@HiveType(typeId: 1) // Assign a unique typeId
class ProfileData extends HiveObject {
  @HiveField(0)
  num? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? image;

  @HiveField(5)
  num? points;

  @HiveField(6)
  num? credit;

  @HiveField(7)
  String? token;

  ProfileData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.points,
    this.credit,
    this.token,
  });

  // You can keep the `fromJson` constructor as well
  ProfileData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
}
