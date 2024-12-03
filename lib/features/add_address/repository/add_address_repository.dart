import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

import '../model/address_model.dart';

abstract class AddAddressRepository {
  Future<Failure?> addAddress(
      AddressData addressData,BuildContext context);
}