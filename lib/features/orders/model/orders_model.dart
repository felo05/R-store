import 'package:e_commerce/features/add_address/model/address_model.dart';

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
    this.address,
    this.products,
    this.paymentMethod,
  });

  BaseOrders.fromJson(dynamic json) {
    id = json['id'];
    total = json['total'];
    date = json['date'];
    status = json['status'];
    paymentMethod = json['paymentMethod'];

    // Parse address directly
    address = json['address'] != null
        ? AddressData.fromJson(json['address'])
        : null;

    // Parse products directly
    products = (json['products'] as List<dynamic>?)
        ?.map((product) => ProductOrder.fromJson(product))
        .toList();
  }

  String? id;
  num? total;
  String? date;
  String? status;
  int? paymentMethod;
  AddressData? address;
  List<ProductOrder>? products;
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
    id = json['product_id']?.toString() ?? json['id']?.toString();
    name = json['name'];
    price = json['price'];
    image = json['image'];
    quantity = json['quantity'];
  }

  String? id;
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
