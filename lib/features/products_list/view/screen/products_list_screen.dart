import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:e_commerce/core/widgets/back_appbar.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:e_commerce/core/widgets/skeleton_loaders.dart';
import 'package:e_commerce/features/products_list/viewmodel/products_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/Kcolors.dart';
import '../../../home/models/prototype_products_model.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
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

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ProductsListCubit>().state;
      if (state is ProductsListSuccessState) {
        if (state.lastDocument != null) {
          setState(() => _isLoadingMore = true);
          context
              .read<ProductsListCubit>()
              .loadMoreProducts(context, state.products, state.lastDocument)
              .then((_) {
            if (mounted) setState(() => _isLoadingMore = false);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: AppLocalizations.of(context)!.products,
        color: baseColor,
        textColor: Colors.white,
      ),
      body: BlocConsumer<ProductsListCubit, ProductsListState>(
        listener: (context, state) {
          if (state is ProductsListErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: baseColor,
            onRefresh: () async {
              context.read<ProductsListCubit>().getProducts(context);
              // Wait for the state to update
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildProductContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildProductContent(BuildContext context, ProductsListState state) {
    if (state is ProductsListLoadingState) {
      return const ProductGridSkeleton(itemCount: 5,isHorizontal: false,);
    }

    if (state is ProductsListSuccessState || state is ProductsListLoadingMoreState) {
      List<PrototypeProductData> products;
      bool showLoadingMore = false;

      if (state is ProductsListSuccessState) {
        products = state.products;
      } else {
        products = (state as ProductsListLoadingMoreState).currentProducts;
        showLoadingMore = true;
      }

      if (products.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 100),
            Center(
              child: CustomText(
                text: AppLocalizations.of(context)!.no_products_found,
                textSize: 20,
                textColor: Colors.black,
                textWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: products.length + (showLoadingMore ? 1 : 0),
        itemBuilder: (ctx, index) {
          if (index == products.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(color: baseColor),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProductCard(
              product: products[index],
              height: 200,
              isInHome: false,
              reloadAll: true,
            ),
          );
        },
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
            text: AppLocalizations.of(context)!.no_products_found,
            textSize: 20,
            textColor: Colors.black,
            textWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

