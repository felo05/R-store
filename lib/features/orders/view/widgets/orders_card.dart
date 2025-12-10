import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/orders_model.dart';

class OrderDetailsCard extends StatelessWidget {
  final BaseOrders order;

  const OrderDetailsCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if order has valid data
    if (order.products == null || order.products!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100.h,
          width: double.infinity,
          child: Center(
            child: Text(AppLocalizations.of(context)!.no_order_details),
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.all(10.0.r),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "${AppLocalizations.of(context)!.order_id}: ${order.id?.substring(0, 8) ?? 'N/A'}",
                  textSize: 16,
                  textWeight: FontWeight.bold,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: order.status?.toUpperCase() ?? 'PENDING',
                    textSize: 12,
                    textColor: Colors.white,
                    textWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Date
            CustomText(
              text: "${AppLocalizations.of(context)!.date}: ${order.date ?? 'N/A'}",
              textSize: 14,
              textWeight: FontWeight.w600,
              textColor: Colors.grey[600]!,
            ),
            SizedBox(height: 10.h),

            // Payment Method
            Row(
              children: [
                Icon(
                  order.paymentMethod == 1 ? Icons.money : Icons.credit_card,
                  size: 18.r,
                  color: Colors.grey[700],
                ),
                SizedBox(width: 8.w),
                CustomText(
                  text: "${AppLocalizations.of(context)!.payment_method}: ${_getPaymentMethodText(context, order.paymentMethod)}",
                  textSize: 14,
                  textWeight: FontWeight.w600,
                  textColor: Colors.grey[700]!,
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Address
            if (order.address != null) ...[
              CustomText(
                text: AppLocalizations.of(context)!.address,
                textSize: 14,
                textWeight: FontWeight.w600,
              ),
              SizedBox(height: 5.h),
              CustomText(
                text: order.address!.name ?? 'N/A',
                textSize: 13,
                textWeight: FontWeight.w500,
                textColor: Colors.grey[700]!,
              ),
              SizedBox(height: 10.h),
            ],

            // Products
            CustomText(
              text: AppLocalizations.of(context)!.products,
              textSize: 14,
              textWeight: FontWeight.w600,
            ),
            SizedBox(height: 5.h),

            ...order.products!.map((product) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                children: [
                  if (product.image != null && product.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        product.image!,
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 50.w,
                            height: 50.h,
                            color: Colors.grey[300],
                            child: Icon(Icons.image_not_supported, size: 25.r),
                          ),
                      ),
                    ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: product.name ?? 'Product',
                          textSize: 13,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: "${AppLocalizations.of(context)!.qty}: ${product.quantity}",
                          textSize: 12,
                          textWeight: FontWeight.w500,
                          textColor: Colors.grey[600]!,
                        ),
                      ],
                    ),
                  ),
                  CustomText(
                    text: "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                    textSize: 14,
                    textWeight: FontWeight.w600,
                  ),
                ],
              ),
            )).toList(),

            Divider(height: 20.h),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppLocalizations.of(context)!.total_cost,
                  textSize: 16,
                  textWeight: FontWeight.bold,
                ),
                CustomText(
                  text: "\$${order.total?.toStringAsFixed(2) ?? '0.00'}",
                  textSize: 16,
                  textWeight: FontWeight.bold,
                  textColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPaymentMethodText(BuildContext context, int? paymentMethod) {
    switch (paymentMethod) {
      case 1:
        return AppLocalizations.of(context)!.cash_on_delivery;
      case 2:
        return AppLocalizations.of(context)!.credit_card;
      default:
        return 'N/A';
    }
  }
}
