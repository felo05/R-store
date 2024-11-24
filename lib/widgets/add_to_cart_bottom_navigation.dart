import 'package:e_commerce/home/main_screen.dart';
import 'package:e_commerce/home/models/products_model.dart';
import 'package:e_commerce/product_details/cubit/add_to_cart/add_to_cart_cubit.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../constants/kcolors.dart';

class AddToCartBottomNavigation extends StatefulWidget {
  const AddToCartBottomNavigation({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  AddToCartBottomNavigationState createState() =>
      AddToCartBottomNavigationState();
  final ProductData product;
}

class AddToCartBottomNavigationState extends State<AddToCartBottomNavigation> {
  int counter = 1;
  bool isInCart = false;

  @override
  void initState() {
    isInCart = widget.product.inCart!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isInCart
        ? _goToCartContainer()
        : BlocConsumer<AddToCartCubit, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg)));
              }
              if (state is AddToCartSuccessState) {
                setState(() {
                  isInCart = true;
                });
              }
            },
            builder: (context, state) {
              if (state is AddToCartLoadingState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 60.h,
                      width: double.infinity,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: baseColor,
                      ))),
                );
              }
              return _buildAddToCartSection(context);
            },
          );
  }

  Padding _buildAddToCartSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 75.h,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: 15.w),
            IconButton(
                onPressed: () {
                  if (counter > 1) setState(() => counter--);
                },
                icon: Icon(
                  Icons.remove,
                  color: counter > 1 ? baseColor : Colors.grey,
                  size: 24.r,
                )),
            CustomText(
              text: counter.toString(),
              textSize: 20,
              textWeight: FontWeight.w500,
            ),
            IconButton(
                onPressed: () {
                  setState(() => counter++);
                },
                icon: Icon(
                  Icons.add,
                  color: baseColor,
                  size: 24.r,
                )),
            const Spacer(),
            GestureDetector(
              onTap: () {
                context.read<AddToCartCubit>().addToCart(
                      productId: widget.product.id!.toInt(),
                      quantity: counter,
                      context: context,
                      isInCart: false,
                    );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: CustomText(
                    text:
                        "${AppLocalizations.of(context)!.add_to_cart}  |  \$${widget.product.price!.toInt() * counter}",
                    textSize: 16,
                    textColor: Colors.white,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }

  Padding _goToCartContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Get.offAll(MainScreen(selectedIndex: 2));
        },
        child: Container(
          width: double.infinity,
          height: 75.h,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: CustomText(
              text: "Go to cart",
              textSize: 24,
              textWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
