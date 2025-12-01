import 'package:e_commerce/core/errors/api_errors.dart';
import 'package:flutter/cupertino.dart';

abstract class CheckoutRepository {
  Future<Failure?> checkout({required String paymentMethod, required String addressId, required BuildContext context});
}