import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';


abstract class ICheckoutRepository {
  Future<Either<String, Unit>> checkout({required String paymentMethod, required String addressId, required BuildContext context});
}

