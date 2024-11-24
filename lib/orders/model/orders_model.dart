import 'package:e_commerce/add_address/model/address_model.dart';
import 'package:e_commerce/constants/kapi.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:flutter/cupertino.dart';

class OrdersModel {
  OrdersModel({
    this.status,
    this.message,
    this.baseData,
  });

  OrdersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    baseData = json['data'] != null ? BaseData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  BaseData? baseData;
}

class BaseData {
  BaseData({this.orders});

  BaseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      orders = [];
      json['data'].forEach((v) {
        orders?.add(BaseOrders.fromJson(v));
      });
    }
  }

  List<BaseOrders>? orders;
}

class BaseOrders {
  BaseOrders({
    this.id,
    this.total,
    this.date,
    this.status,
  }) ;

  BaseOrders.fromJson(dynamic json) {
    id = json['id'];
    total = json['total'];
    date = json['date'];
    status = json['status'];
    _orderDetailsFuture = _fetchOrderDetails();
  }

  num? id;
  num? total;
  String? date;
  String? status;

  late final Future<OrderDetails> _orderDetailsFuture;

  Future<OrderDetails> _fetchOrderDetails() async {
    try {
      final response = await DioHelpers.getData(path: "${Kapi.orders}/$id");
      if (response.data != null) {
        return OrderDetails.fromJson(response.data);
      } else {
        throw Exception("Response data is null");
      }
    } catch (e) {
      debugPrint("Error fetching order details: $e");
      throw Exception("Failed to fetch order details: $e");
    }
  }


  Future<OrderDetails> get orderDetails => _orderDetailsFuture;
}


class ProductOrder {
  ProductOrder({
    this.id,
    this.name,
    this.price,
    this.image,
    this.quantity,
  });

  ProductOrder.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    quantity = json['quantity'];
  }

  num? id;
  String? name;
  num? price;
  String? image;
  num? quantity;
}

class OrderDetails {
  OrderDetails({
    this.status,
    this.message,
    this.address,
    this.total,
    this.date,
    this.products,
  });
  OrderDetails.fromJson(dynamic json) {
    try {
      status = json['status'];
      message = json['message'];
      address = json["data"]?['address'] != null
          ? AddressData.fromJson(json["data"]['address'])
          : null;
      total = json["data"]?['total'];
      date = json["data"]?['date'];
      products = (json["data"]?['products'] as List<dynamic>?)
          ?.map((product) => ProductOrder.fromJson(product))
          .toList();
    } catch (e) {
      throw Exception("Error parsing OrderDetails: $e");
    }
  }


  bool? status;
  String? message;
  AddressData? address;
  num? total;
  String? date;
  List<ProductOrder>? products;
}
