import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:e_commerce/features/favorites/cubit/get_favorites_cubit/get_favorite_cubit.dart';
import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: AppLocalizations.of(context)!.favorite_products,
          textSize: 24,
          textWeight: FontWeight.bold,
          textColor: baseColor,
        ),
      ),
      body: BlocConsumer<GetFavoriteCubit, GetFavoriteState>(
        listener: (context, state) {
          if (state is GetFavoriteErrorState) {
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
              context.read<GetFavoriteCubit>().getFavorites(context);
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
                  final List<FavoriteData> products =
                      state.favoriteModel.data?.data ?? [];

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
