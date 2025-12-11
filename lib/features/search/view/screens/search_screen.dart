import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/core/widgets/skeleton_loaders.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:e_commerce/features/search/repository/i_search_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce/core/widgets/custom_text_field.dart';
import 'package:e_commerce/core/di/service_locator.dart';

import '../../viewmodel/search_cubit.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(sl<ISearchRepository>()),
      child: const _SearchScreenContent(),
    );
  }
}

class _SearchScreenContent extends StatefulWidget {
  const _SearchScreenContent();

  @override
  State<_SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<_SearchScreenContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

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
      final state = context.read<SearchCubit>().state;
      if (state is SearchSuccessState) {
        if (state.products.lastDocument != null) {
          setState(() => _isLoadingMore = true);
          context.read<SearchCubit>().loadMoreSearchResults(state.query, context, state.products).then((_) {
            if (mounted) setState(() => _isLoadingMore = false);
          });
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: BackAppBar(
        title: AppLocalizations.of(context)!.search,
        color: backgroundColor,
        textColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 8.w, top: 5.h, left: 8.w),
        child: Column(
          children: [
            CustomTextField(
              prefixIcon: CupertinoIcons.search,
              text: AppLocalizations.of(context)!.search,
              onSubmit: (value) {
                if (value.isNotEmpty) {
                  context.read<SearchCubit>().searchProduct(value, context);
                }
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            BlocConsumer<SearchCubit, SearchState>(
              listener: (context, state) {
                if (state is SearchErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is SearchLoadingState) {
                  return const Expanded(
                    child: ProductGridSkeleton(itemCount: 6,isHorizontal: false,),
                  );
                }
                if (state is SearchSuccessState || state is SearchLoadingMoreState) {
                  BaseProductData products;
                  bool showLoadingMore = false;

                  if (state is SearchSuccessState) {
                    products = state.products;
                  } else {
                    products = (state as SearchLoadingMoreState).currentProducts;
                    showLoadingMore = true;
                  }

                  if (products.data!.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(height: 150.h),
                        Center(
                          child: CustomText(
                            text: AppLocalizations.of(context)!.no_products_found,
                            textSize: 26,
                            textWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: (products.data?.length ?? 0) + (showLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == products.data!.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return ProductCard(
                          product: products.data![index],
                          height: 150,
                          isInHome: false,
                          reloadAll: true,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
