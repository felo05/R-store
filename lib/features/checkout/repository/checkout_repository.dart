import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

abstract class CheckoutRepository {
  Future<Failure?> checkout({required int paymentMethod, required int addressId,required BuildContext context});
}