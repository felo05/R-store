import 'package:e_commerce/features/add_address/model/address_model.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:e_commerce/features/checkout/cubit/checkout_cubit.dart';
import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/helpers/dio_helper.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core//widgets/custom_dropdown.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../add_address/map_screen.dart';
import '../home/main_screen.dart';

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
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CustomText(
                    text: AppLocalizations.of(context)!.add_new_address,
                    textSize: 18,
                    textColor: baseColor,
                    textWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.add, color: baseColor),
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
       DropdownMenuItem(
        value: "1",
        child: CustomText(
          text: AppLocalizations.of(context)!.cash_on_delivery,
          textSize: 16,
          textWeight: FontWeight.w500,
        ),
      ),
       DropdownMenuItem(
        value: "2",
        child: CustomText(
          text: AppLocalizations.of(context)!.credit_card,
          textSize: 16,
          textWeight: FontWeight.w500,
        ),
      ),
    ];

    return Scaffold(
      appBar:  BackAppBar(
          title: AppLocalizations.of(context)!.checkout, color: baseColor, textColor: Colors.black),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomDropdown(
                    label: AppLocalizations.of(context)!.payment_method,
                    items: paymentMethodsItems,
                    validator: (value) {
                      if (value == null) {
                        return AppLocalizations.of(context)!.please_select_a_payment_method;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      selectedPaymentMethod = int.parse(value!);
                    },
                  ),
                  CustomDropdown(
                    label: AppLocalizations.of(context)!.address,
                    items: addressItems,
                    validator: (value) {
                      if (value == null) {
                        return AppLocalizations.of(context)!.please_select_an_address;
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
                          text: AppLocalizations.of(context)!.qty+product.quantity.toString(),
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
                   CustomText(
                      text: AppLocalizations.of(context)!.total_cost,
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
                  if (state is CheckoutSuccessState) {
                    Get.offAll(() => const MainScreen(initialIndex: 0));
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
                      child:  Center(
                        child: CustomText(
                          text: AppLocalizations.of(context)!.checkout,
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
