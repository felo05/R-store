import 'package:e_commerce/features/cart/viewmodel/get_cart/cart_cubit.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/features/cart/view/widgets/cart_product_card.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/checkout/view/screens/checkout_screen.dart';

import '../../../../core/di/service_locator.dart';
import '../../repository/i_cart_repository.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(sl<ICartRepository>())..getCart(context),
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
          },
        ),
        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            // Calculate total from CartCubit state
            final cartData = state is CartSuccessState 
                ? state.cartResponse 
                : null;
            final total = cartData?.total ?? 0;
            final products = cartData?.cartItems ?? [];

            return Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
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
                    onPressed: total <= 0 || products.isEmpty ? null : () {
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
                      textColor: total <= 0 || products.isEmpty ? Colors.grey : baseColor,
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
      final products = state.cartResponse.cartItems ?? [];
      
      if (products.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 100),
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
        );
      }

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final cartItem = products[index];
          return CartItemCard(
            cartItem: cartItem,
            onRemoveAll: (num removedTotal) {
              // Remove item using CartCubit method
              context.read<CartCubit>().removeItem(cartItem.id);
            },
            onChange: (num changeAmount) {
              // CartItemCard updates quantity locally and calls changeQuantityCloudly
              // We need to sync the CartCubit state with the new total
              // Since CartItemCard already updated Firebase, we just update the total here
              final currentState = context.read<CartCubit>().state;
              if (currentState is CartSuccessState) {
                final currentItems = currentState.cartResponse.cartItems ?? [];
                // Calculate new total by adding/subtracting the change amount
                final newTotal = (currentState.cartResponse.total ?? 0) + changeAmount;
                
                // Update state with new total (quantity is already updated in Firebase by CartItemCard)
                context.read<CartCubit>().emitSuccessState(
                  CartData(cartItems: currentItems, total: newTotal),
                );
              }
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
