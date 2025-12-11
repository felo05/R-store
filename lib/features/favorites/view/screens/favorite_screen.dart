import 'package:e_commerce/core/constants/Kcolors.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:e_commerce/core/widgets/skeleton_loaders.dart';
import 'package:e_commerce/features/favorites/model/favorite_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../viewmodel/get_favorite_cubit.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<GetFavoriteCubit>().state;
      if (state is GetFavoriteSuccessState) {
        if (state.favoriteModel.data?.lastDocument != null) {
          setState(() => _isLoadingMore = true);
          context.read<GetFavoriteCubit>().loadMoreFavorites(context, state.favoriteModel).then((_) {
            if (mounted) setState(() => _isLoadingMore = false);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Must call super.build for AutomaticKeepAlive
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
                  return const ProductGridSkeleton(itemCount: 6,isHorizontal: false,);
                }

                List<Widget> favoriteWidgets = [];
                bool showLoadingMore = false;

                if (state is GetFavoriteSuccessState || state is GetFavoriteLoadingMoreState) {
                  FavoriteModel favoriteModel;

                  if (state is GetFavoriteSuccessState) {
                    favoriteModel = state.favoriteModel;
                  } else {
                    favoriteModel = (state as GetFavoriteLoadingMoreState).currentData;
                    showLoadingMore = true;
                  }

                  final List<FavoriteData> products = favoriteModel.data?.data ?? [];

                  if (products.isEmpty) {
                    // Use SizedBox with full height to make the empty state scrollable
                    return CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CustomText(
                              text: AppLocalizations.of(context)!
                                  .no_favorite_products_added_yet,
                              textSize: 18,
                              textWeight: FontWeight.w500,
                              textColor: baseColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    favoriteWidgets = products.map<Widget>((favoriteProduct) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ProductCard(
                          isInHome: false,
                          product: favoriteProduct.product!,
                          height: 150,
                          reloadAll: false,
                        ),
                      );
                    }).toList();

                    // Add loading indicator at the bottom when loading more
                    if (showLoadingMore) {
                      favoriteWidgets.add(
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(color: baseColor),
                          ),
                        ),
                      );
                    }
                  }
                }

                return ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
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
