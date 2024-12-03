import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 200.h,
                width: double.infinity,
                child: const Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 200.h,
                width: double.infinity,
                child: Center(
                    child: Text(
                        AppLocalizations.of(context)!.failed_to_load_order))),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 200.h,
                width: double.infinity,
                child: Text(AppLocalizations.of(context)!.no_order_details)),
          ));
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
                  text:
                      "${AppLocalizations.of(context)!.order_id}: ${order.id}",
                  textSize: 18,
                  textWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.0.h),
                CustomText(
                  text: "${AppLocalizations.of(context)!.date}: ${order.date}",
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
                CustomText(
                  text:
                      "${AppLocalizations.of(context)!.total}\$${order.total}",
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
                const Divider(),
                CustomText(
                  text:
                      "${AppLocalizations.of(context)!.address}: ${details.address?.name ?? AppLocalizations.of(context)!.no_address_provided}\n${details.address?.details ?? ''}",
                  textSize: 18,
                  textWeight: FontWeight.w600,
                ),
                SizedBox(height: 10.0.h),
                CustomText(
                  text: AppLocalizations.of(context)!.products,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
                ...?details.products?.map((product) => ListTile(
                      title: CustomText(
                        text: product.name ?? "",
                        textSize: 16,
                        textWeight: FontWeight.w500,
                      ),
                      subtitle: CustomText(
                        text: AppLocalizations.of(context)!.qty +
                            product.quantity.toString(),
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
