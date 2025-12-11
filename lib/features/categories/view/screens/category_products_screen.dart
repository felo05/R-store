import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../repository/i_categories_repository.dart';
import '../../viewmodel/category_products/category_products_cubit.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({
    super.key,
    required this.title,
    required this.categoryID,
  });

  final int categoryID;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryProductsCubit(sl<ICategoriesRepository>())..getProductsByCategory(categoryID, context),
      child: Scaffold(
          appBar: BackAppBar(
            title: title,
            color: baseColor,
            textColor: Colors.white,
          ),
          body: BlocConsumer<CategoryProductsCubit, CategoryProductsState>(
            listener: (context, state) {
              if (state is CategoryProductsErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CategoryProductsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CategoryProductsSuccessState) {
                List<ProductData> products = state.products;
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                          product: products[index],
                          height: 200,
                          isInHome: true,
                          reloadAll: true);
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )),
    );
  }
}
