import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/products_list/cubit/category_products_cubit.dart';
import 'package:e_commerce/home/models/products_model.dart';
import 'package:e_commerce/widgets/back_appbar.dart';
import 'package:e_commerce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProductListScreen extends StatelessWidget {
   const ProductListScreen(
      {super.key, required this.title, required this.categoryID,});

  final int categoryID;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>CategoryProductsCubit()..getProductsByCategory(categoryID),
      child: Scaffold(
          appBar: BackAppBar(title: title, color:baseColor, textColor: Colors.white,),
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
                      return ProductCard(product: products[index], height: 200,isInHome: true,reloadAll: true);
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
