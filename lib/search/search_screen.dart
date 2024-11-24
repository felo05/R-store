import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/home/models/products_model.dart';
import 'package:e_commerce/search/cubit/search_cubit.dart';
import 'package:e_commerce/widgets/back_appbar.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_text_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const BackAppBar(
          title: "Search", color: backgroundColor, textColor: Colors.black,),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.only(right: 8.w, top: 5.h, left: 8.w),
          child: Column(
            children: [
              CustomTextField(
                prefixIcon: CupertinoIcons.search,
                text: AppLocalizations.of(context)!.search,
                onSubmit: (value) {
                  if (value.isNotEmpty) {
                    context.read<SearchCubit>().searchProduct(value);
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
                    List<ProductData> products = state.products;
                    if (products.isEmpty) {
                      return const Center(
                        child: CustomText(
                            text: "No result",
                            textSize: 26,
                            textWeight: FontWeight.bold)
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                              product: products[index],
                              height: 150,
                              isInHome: false,
                              reloadAll: true);
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
      ),
    );
  }
}
