import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:e_commerce/features/add_address/model/address_model.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/kapi.dart';
import '../../../core/helpers/dio_helper.dart';
import 'add_address_repository.dart';

class AddAddressRepositoryImplementation implements AddAddressRepository {
  @override
  Future<Failure?> addAddress(AddressData addressData, BuildContext context) async {
    try {
      final response=await DioHelpers.postData(path: Kapi.addresses, body: {
        'latitude': addressData.latitude,
        'longitude': addressData.longitude,
        'notes': addressData.notes,
        'name': addressData.name,
        'details': addressData.details,
        'region': addressData.region,
        'city': addressData.city,
      });
      if(response.data["status"] == false) return (ServerFailure(response.data["message"]));

      return null;
    } catch (e) {
      if (e is DioException) return (ServerFailure.fromDioError(e,context));
      return ServerFailure(e.toString());
    }
  }
}
