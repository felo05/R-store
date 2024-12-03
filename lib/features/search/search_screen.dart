import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/search/cubit/search_cubit.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/widgets/custom_text_field.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: _SearchScreenContent(),
    );
  }
}

class _SearchScreenContent extends StatelessWidget {
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SearchSuccessState) {
                  BaseProductData products = state.products;
                  if (products.data!.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: AppLocalizations.of(context)!.no_products_found,
                        textSize: 26,
                        textWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: products.data?.length,
                      itemBuilder: (context, index) {
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
