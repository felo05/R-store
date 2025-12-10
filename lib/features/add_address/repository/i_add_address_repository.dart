import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import '../model/address_model.dart';

abstract class IAddAddressRepository {
  Future<Either<String, Unit>> addAddress(
      AddressData addressData,BuildContext context);
}

