import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:e_commerce/features/product_details/cubit/add_to_cart/add_to_cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../features/cart/cubit/get_cart/cart_cubit.dart';
import '../../features/product_details/product_details_screen.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final void Function(int) onChange;
  final void Function(int) onRemoveAll;

  const CartItemCard({
    Key? key,
    required this.cartItem,
    required this.onChange,
    required this.onRemoveAll,
  }) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late int quantity;

  @override
  void initState() {
    quantity = widget.cartItem.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      elevation: 3,
      child: GestureDetector(
        onTap: () {
          Get.to(ProductDetailsScreen(product: widget.cartItem.product));
        },
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Row(
            children: [
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: CustomNetworkImage(
                  image: widget.cartItem.product.image!,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.product.name!,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "\$${(quantity * widget.cartItem.product.price!).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Quantity Controls
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            quantity--;
                            widget.onChange(
                                -widget.cartItem.product.price!.toInt());
                            CartCubit.changeQuantityCloudly(
                                quantity: quantity,
                                productId: widget.cartItem.product.id!.toInt());
                            setState(() {});
                          }
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: quantity > 1 ? Colors.red : Colors.grey,
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          quantity++;
                          widget
                              .onChange(widget.cartItem.product.price!.toInt());
                          CartCubit.changeQuantityCloudly(
                            quantity: quantity,
                            productId: widget.cartItem.id.toInt(),
                          );
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      AddToCartCubit.removeFromCart(
                        productId: widget.cartItem.product.id!.toInt(),
                        context: context,
                      );
                      widget.onRemoveAll(quantity*
                          widget.cartItem.product.price!.toInt());
                    },
                    child: CustomText(
                      text: AppLocalizations.of(context)!.remove,
                      textColor: Colors.black,
                      textSize: 18,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
