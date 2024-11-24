import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/favorites/cubit/get_favorite_cubit.dart';
import 'package:e_commerce/home/models/products_model.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';

import '../login/login_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.favorite_products,
          textSize: 22,
          textWeight: FontWeight.bold,
        ),
      ),
      body: BlocConsumer<GetFavoriteCubit, GetFavoriteState>(
        listener: (context, state) {
          if (state is GetFavoriteTokenExpireState) {
            Get.offAll(LoginScreen());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: CustomText(
                  text: AppLocalizations.of(context)!.session_ended,
                  textSize: 16,
                  textWeight: FontWeight.w400,
                ),
              ),
            );
          } else if (state is GetFavoriteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: CustomText(
                  text: state.msg,
                  textSize: 16,
                  textWeight: FontWeight.w400,
                ),
              ),
            );
          }
        },
        builder: (BuildContext context, GetFavoriteState state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<GetFavoriteCubit>().getFavorites();
            },
            child: Builder(
              builder: (context) {
                if (state is GetFavoriteLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: baseColor),
                  );
                }

                List<Widget> favoriteWidgets = [];

                if (state is GetFavoriteSuccessState) {
                  final favorite =
                      context.read<GetFavoriteCubit>().favoriteModel;
                  final products = favorite.data?.data ?? [];

                  if (products.isEmpty) {
                    favoriteWidgets.add(
                      Center(
                        child: CustomText(
                          text: AppLocalizations.of(context)!
                              .no_favorite_products_added_yet,
                          textSize: 18,
                          textWeight: FontWeight.w500,
                          textColor: baseColor,
                        ),
                      ),
                    );
                  } else {
                    favoriteWidgets = products.map((favoriteProduct) {
                      return ProductCard(
                        isInHome: false,
                        product: favoriteProduct.product ?? ProductData(),
                        height: 150,
                        reloadAll: false,
                      );
                    }).toList();
                  }
                }

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: favoriteWidgets,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
