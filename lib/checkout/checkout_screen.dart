import 'package:e_commerce/add_address/model/address_model.dart';
import 'package:e_commerce/cart/model/cart_model.dart';
import 'package:e_commerce/checkout/cubit/checkout_cubit.dart';
import 'package:e_commerce/constants/Kcolors.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/widgets/back_appbar.dart';
import 'package:e_commerce/widgets/custom_dropdown.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../add_address/map_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.products});

  final CartData products;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<DropdownMenuItem<String>> addressItems = [];
  bool isLoadingAddresses = true;

  @override
  void initState() {
    super.initState();
    DioHelpers.getData(path: "addresses").then((value) {
      final addressModel = AddressModel.fromJson(value.data);
      setState(() {
        for (var address in addressModel.baseData!.addressData!) {
          addressItems.add(DropdownMenuItem(
            value: address.id.toString(),
            child: CustomText(
              text: address.name!,
              textSize: 16,
              textWeight: FontWeight.w500,
            ),
          ));
        }
        addressItems.add(DropdownMenuItem(
          value: "null",
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              Get.to(() => const LocationPickerScreen());
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CustomText(
                    text: "Add New Address  ",
                    textSize: 18,
                    textColor: baseColor,
                    textWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.add, color: baseColor),
              ],
            ),
          ),
        ));
        isLoadingAddresses = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int? selectedPaymentMethod;
    int? selectedAddress;
    final List<DropdownMenuItem<String>> paymentMethodsItems = [
      const DropdownMenuItem(
        value: "1",
        child: CustomText(
          text: "Cash on Delivery",
          textSize: 16,
          textWeight: FontWeight.w500,
        ),
      ),
      const DropdownMenuItem(
        value: "2",
        child: CustomText(
          text: "Credit Card",
          textSize: 16,
          textWeight: FontWeight.w500,
        ),
      ),
    ];

    return Scaffold(
      appBar: const BackAppBar(
          title: "Checkout", color: baseColor, textColor: Colors.black),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomDropdown(
                    label: "Payment Methods",
                    items: paymentMethodsItems,
                    validator: (value) {
                      if (value == null) {
                        return "Please select a payment method";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      selectedPaymentMethod = int.parse(value!);
                    },
                  ),
                  CustomDropdown(
                    label: "Address",
                    items: addressItems,
                    validator: (value) {
                      if (value == null) {
                        return "Please select an address";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      selectedAddress = int.parse(value!);
                    },
                    isLoading: isLoadingAddresses, // Pass the loading state
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.products.cartItems!.length,
                itemBuilder: (context, index) {
                  final product = widget.products.cartItems![index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 150.w,
                            child: CustomText(
                              text: product.product.name!,
                              textSize: 16,
                              textWeight: FontWeight.w500,
                              maxLines: 2,
                            )),
                        CustomText(
                          text: "Qty: ${product.quantity}",
                          textSize: 16,
                          textWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                        CustomText(
                          text:
                              "\$${(product.product.price! * product.quantity).toStringAsFixed(2)}",
                          textSize: 16,
                          textWeight: FontWeight.w500,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                      text: "Total Cost",
                      textSize: 18,
                      textWeight: FontWeight.bold),
                  CustomText(
                      text: "\$${widget.products.total!.toStringAsFixed(2)}",
                      textSize: 18,
                      textWeight: FontWeight.bold),
                ],
              ),
            ),
            BlocProvider(
              create: (context) => CheckoutCubit(),
              child: BlocConsumer<CheckoutCubit, CheckoutState>(
                listener: (context, state) {
                  if (state is CheckoutErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is CheckoutLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: baseColor,
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<CheckoutCubit>().checkout(
                            paymentMethod: selectedPaymentMethod!,
                            context: context,
                            addressId: selectedAddress!);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: CustomText(
                          text: "Checkout",
                          textColor: Colors.white,
                          textWeight: FontWeight.w500,
                          textSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
