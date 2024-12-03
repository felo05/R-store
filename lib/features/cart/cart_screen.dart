import 'package:e_commerce/features/cart/cubit/change_total/change_total_cubit.dart';
import 'package:e_commerce/features/cart/cubit/get_cart/cart_cubit.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:e_commerce/features/favorites/cubit/get_favorites_cubit/get_favorite_cubit.dart';
import 'package:e_commerce/features/home/cubits/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';

import '../../core/constants/Kcolors.dart';
import '../../core/widgets/cart_product_card.dart';
import '../../core/widgets/custom_text.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int total = 0;

  List<CartItem> products = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeTotalCubit(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: CustomText(
            text: AppLocalizations.of(context)!.your_cart,
            textSize: 22,
            textWeight: FontWeight.bold,
          ),
        ),
        body: BlocConsumer<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: baseColor),
              );
            }

            if (state is CartSuccessState) {
              products = state.cartResponse.data?.cartItems ?? [];
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CartCubit>().getCart(context);
                },
                child: products.isEmpty
                    ? ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Center(
                      child: CustomText(
                        text: AppLocalizations.of(context)!
                            .no_products_added_to_cart_yet,
                        textSize: 18,
                        textWeight: FontWeight.w500,
                        textColor: baseColor,
                      ),
                    ),
                  ],
                )
                    : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return CartItemCard(
                          cartItem: products[index],
                          onRemoveAll: (int total) {
                            products.removeAt(index);
                            this.total -= total;
                            setState(() {});
                            context
                                .read<ProductsCubit>()
                                .getProducts(context);
                            context
                                .read<GetFavoriteCubit>()
                                .getFavorites(context);
                          },
                          onChange: (int total) {
                            this.total += total;
                            context.read<ChangeTotalCubit>().changeTotal();
                          },
                        );
                      },
                    ),
              );
            }
            return const SizedBox.shrink();
          },
          listener: (BuildContext context, CartState state) {
            if (state is CartErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CustomText(
                    text: state.msg,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                    textColor: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        bottomNavigationBar: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartSuccessState) {
              total = state.cartResponse.data!.total!.toInt();
            }
          },
          builder: (context, state) {
            if (state is CartLoadingState) {
              total = 0;
            }
            return Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: BlocBuilder<ChangeTotalCubit, ChangeTotalState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      CustomText(
                        text: AppLocalizations.of(context)!.total,
                        textSize: 24,
                        textWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: "\$${total.toStringAsFixed(2)}",
                        textSize: 18,
                        textWeight: FontWeight.bold,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(() =>
                              CheckoutScreen(
                                products:
                                CartData(cartItems: products, total: total),
                              ));
                        },
                        child: CustomText(
                          text: AppLocalizations.of(context)!.checkout,
                          textSize: 24,
                          textWeight: FontWeight.bold,
                          textColor: total <= 0 ? Colors.grey : baseColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
