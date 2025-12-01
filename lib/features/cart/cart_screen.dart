import 'package:e_commerce/features/cart/cubit/change_total/change_total_cubit.dart';
import 'package:e_commerce/features/cart/cubit/get_cart/cart_cubit.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:e_commerce/features/favorites/cubit/get_favorites_cubit/get_favorite_cubit.dart';
import 'package:e_commerce/features/home/cubits/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/localization/l10n/app_localizations.dart';
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
  num total = 0;
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
            textSize: 24,
            textColor: baseColor,
            textWeight: FontWeight.bold,
          ),
        ),
        body: BlocConsumer<CartCubit, CartState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: baseColor,
              onRefresh: () async {
                context.read<CartCubit>().getCart(context);
                // Wait for the state to update
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: _buildCartContent(state, context),
            );
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
            if (state is CartSuccessState) {
              setState(() {
                products = state.cartResponse.cartItems ?? [];
                total = (state.cartResponse.total ?? 0);
              });
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<ChangeTotalCubit, ChangeTotalState>(
          builder: (context, changeState) {
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
              child: Row(
                children: [
                  CustomText(
                    text: AppLocalizations.of(context)!.total,
                    textSize: 24,
                    textWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: "\$${total.toStringAsFixed(2)}",
                    textSize: 18,
                    textWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: total <= 0 ? null : () {
                      Get.to(
                        CheckoutScreen(
                          products: CartData(cartItems: products, total: total),
                        ),
                      );
                    },
                    child: CustomText(
                      text: AppLocalizations.of(context)!.checkout,
                      textSize: 24,
                      textWeight: FontWeight.bold,
                      textColor: total <= 0 ? Colors.grey : baseColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(CartState state, BuildContext context) {
    if (state is CartLoadingState) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(
            child: CircularProgressIndicator(color: baseColor),
          ),
        ],
      );
    }

    if (state is CartSuccessState) {
      if (products.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 100),
            Center(
              child: CustomText(
                text: AppLocalizations.of(context)!.no_products_added_to_cart_yet,
                textSize: 18,
                textWeight: FontWeight.w500,
                textColor: baseColor,
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return CartItemCard(
            cartItem: products[index],
            onRemoveAll: (num removedTotal) {
              setState(() {
                total -= removedTotal;
                products.removeAt(index);
              });
              context.read<CartCubit>().emitSuccessState(
                CartData(cartItems: products, total: total),
              );
              context.read<ProductsCubit>().getProducts(context);
              context.read<GetFavoriteCubit>().getFavorites(context);
              context.read<ChangeTotalCubit>().changeTotal();
            },
            onChange: (num changeAmount) {
              setState(() {
                total += changeAmount;
              });
              context.read<ChangeTotalCubit>().changeTotal();
            },
          );
        },
      );
    }

    // Error or initial state
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 100),
        Center(
          child: CustomText(
            text: AppLocalizations.of(context)!.no_products_added_to_cart_yet,
            textSize: 18,
            textWeight: FontWeight.w500,
            textColor: baseColor,
          ),
        ),
      ],
    );
  }
}
