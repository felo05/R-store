import 'package:e_commerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'model/orders_model.dart';

class OrderDetailsCard extends StatelessWidget {
  final BaseOrders order;

  const OrderDetailsCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderDetails>(
      future: order.orderDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint("Error fetching order details: ${snapshot.error}");
          return const Center(child: Text("Failed to load order details."));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No order details available."));
        }

        final details = snapshot.data!;
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
                CustomText(
                  text: "Order ID: ${order.id}",
                  textSize: 18,
                  textWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.0.h),
                CustomText(
                  text: "Date: ${order.date}",
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
                CustomText(
                  text: "Total: \$${order.total}",
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
                const Divider(),
                CustomText(
                  text:
                  "Address: ${details.address?.name ?? 'No address provided'}\n${details.address?.details ?? ''}",
                  textSize: 18,
                  textWeight: FontWeight.w600,
                ),
                SizedBox(height: 10.0.h),
                const CustomText(
                  text: "Products:",
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
                ...?details.products?.map((product) => ListTile(
                  title: CustomText(
                    text: product.name ?? "Unknown Product",
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                  subtitle: CustomText(
                    text: "Quantity: ${product.quantity}",
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                  trailing: CustomText(
                    text: "\$${product.price}",
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );

  }
}
