import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/features/favorites/repository/i_favorites_repository.dart';
import 'package:e_commerce/features/product_details/view/widgets/add_to_cart_bottom_navigation.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/product_details/viewmodel/products_in_details/products_in_details_cubit.dart';
import 'package:e_commerce/features/product_details/viewmodel/get_product/get_product_cubit.dart';
import 'package:e_commerce/features/product_details/viewmodel/add_to_cart/add_to_cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce/core/widgets/horizontal_products_header.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:e_commerce/features/favorites/viewmodel/get_favorite_cubit.dart';
import 'package:e_commerce/features/home/models/products_model.dart';

import '../../repository/i_product_details_repository.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductData? product;
  final int? productId;

  const ProductDetailsScreen({
    super.key,
    this.product,
    this.productId,
  }) : assert(product != null || productId != null,
            'Either product or productId must be provided');

  bool _needsDataFetch() {
    return product == null ||
        product!.images == null ||
        product!.images!.isEmpty ||
        product!.discount == null ||
        product!.description == null;
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with AddToCartCubit provider
    return BlocProvider(
      create: (context) => AddToCartCubit(sl<IProductDetailsRepository>()),
      child: Builder(
        builder: (context) {
          // If we need to fetch data, use BlocProvider with GetProductCubit
          if (_needsDataFetch()) {
            final idToFetch = productId ?? product!.id?.toInt();
            if (idToFetch == null) {
              return Scaffold(
                appBar: AppBar(
                  title: CustomText(
                    text: AppLocalizations.of(context)!.product_details,
                    textSize: 22,
                    textColor: Colors.black,
                    textWeight: FontWeight.bold,
                  ),
                ),
                body: const Center(
                  child: CustomText(
                    text: 'Invalid product ID',
                    textSize: 16,
                    textColor: Colors.red,
                    textWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return BlocProvider(
              create: (context) => GetProductCubit(sl<IProductDetailsRepository>())
                ..getProduct(idToFetch, context),
              child: BlocBuilder<GetProductCubit, GetProductState>(
                builder: (context, state) {
                  if (state is GetProductLoadingState) {
                    return Scaffold(
                      appBar: AppBar(
                        title: CustomText(
                          text: AppLocalizations.of(context)!.product_details,
                          textSize: 22,
                          textColor: Colors.black,
                          textWeight: FontWeight.bold,
                        ),
                      ),
                      body: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is GetProductErrorState) {
                    return Scaffold(
                      appBar: AppBar(
                        title: CustomText(
                          text: AppLocalizations.of(context)!.product_details,
                          textSize: 22,
                          textColor: Colors.black,
                          textWeight: FontWeight.bold,
                        ),
                      ),
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: state.errorMsg,
                              textSize: 16,
                              textColor: Colors.red,
                              textWeight: FontWeight.normal,
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<GetProductCubit>()
                                    .getProduct(idToFetch, context);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is GetProductSuccessState) {
                    return _ProductDetailsContent(product: state.product);
                  }
                  return const SizedBox.shrink();
                },
              ),
            );
          }

          // If we have complete product data, render directly
          return _ProductDetailsContent(product: product!);
        },
      ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final ProductData product;

  const _ProductDetailsContent({required this.product});

  @override
  Widget build(BuildContext context) {
    List<String> images = product.images ?? [product.image.toString()];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: AppLocalizations.of(context)!.product_details,
          textSize: 22,
          textColor: Colors.black,
          textWeight: FontWeight.bold,
        ),
        actions: [
          _FavoriteIcon(product: product),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CarouselSlider(
                items: images.map((image) {
                  return SizedBox(
                    height: 300.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: CustomNetworkImage(image: image),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250.h,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.7,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 850),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomText(
                  text: product.name!,
                  textSize: 22,
                  textWeight: FontWeight.bold,
                  textAlign: TextAlign.justify),
              const SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: baseColor,
                    size: 20.r,
                  ),
                  Icon(
                    Icons.star,
                    color: baseColor,
                    size: 20.r,
                  ),
                  Icon(
                    Icons.star,
                    color: baseColor,
                    size: 20.r,
                  ),
                  Icon(
                    Icons.star,
                    color: baseColor,
                    size: 20.r,
                  ),
                  Icon(
                    Icons.star_border,
                    color: Colors.grey,
                    size: 20.r,
                  ),
                  CustomText(
                      text: AppLocalizations.of(context)!.reviews,
                      textSize: 17,
                      textWeight: FontWeight.w500)
                ],
              ),
              SizedBox(height: 15.h),
              product.discount == 0
                  ? Row(
                      children: [
                        CustomText(
                            text: "\$${product.price}",
                            textSize: 20,
                            textWeight: FontWeight.w500,
                            textColor: Colors.black,
                            textAlign: TextAlign.start),
                      ],
                    )
                  : Row(
                      children: [
                        CustomText(
                            text: "\$${product.price}",
                            textSize: 20,
                            textWeight: FontWeight.w500,
                            textColor: Colors.black,
                            textAlign: TextAlign.start),
                        SizedBox(width: 10.w),
                        CustomText(
                            text: "\$${product.oldPrice}",
                            textSize: 18,
                            lineThrough: true,
                            textColor: Colors.grey,
                            textWeight: FontWeight.w500),
                        SizedBox(width: 10.w),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: baseColor),
                          child: CustomText(
                              text:
                                  "${product.discount}% ${AppLocalizations.of(context)!.off}",
                              textSize: 14,
                              textColor: Colors.white,
                              textWeight: FontWeight.w400),
                        ),
                      ],
                    ),
              SizedBox(height: 25.h),
              ExpandableCustomText(
                  text: product.description!,
                  textSize: 16,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  textWeight: FontWeight.w400,
                  textAlign: TextAlign.justify),
              SizedBox(height: 20.h),
              HorizontalProductsHeader(
                  text: AppLocalizations.of(context)!.similar_products),
              SizedBox(height: 10.h),
              BlocProvider(
                create: (context) =>
                    ProductsInDetailsCubit(sl<IProductDetailsRepository>())
                      ..getProducts(context),
                child:
                    BlocBuilder<ProductsInDetailsCubit, ProductsInDetailsState>(
                  builder: (context, state) {
                    if (state is ProductsInDetailsLoadingState) {
                      return SizedBox(
                          height: 225.h,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    } else if (state is ProductsInDetailsSuccessState) {
                      final allProducts = state.productsModel.data?.data ?? [];
                      // Filter out the current product from similar products
                      final currentProductId = product.id?.toString();
                      final similarProducts = allProducts.where((p) {
                        if (p.id == null || currentProductId == null) {
                          return true; // Include if we can't compare
                        }
                        return p.id.toString() != currentProductId;
                      }).toList();

                      return SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: similarProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: similarProducts[index],
                              height: 130,
                              isInHome: true,
                              reloadAll: true,
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AddToCartBottomNavigation(
        product: product,
      ),
    );
  }
}

class _FavoriteIcon extends StatefulWidget {
  const _FavoriteIcon({
    required this.product,
  });

  final ProductData product;

  @override
  State<_FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<_FavoriteIcon> {
  late bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.product.inFavorites!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () async {
        // Safely convert product id to string, handling null case
        final productId = widget.product.id?.toString() ?? '';
        if (productId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product ID is missing')),
          );
          return;
        }

        sl<IFavoritesRepository>().addFavorite(productId, context, true, true);

        // Only update favorites list, no need to refetch all products and cart
        context.read<GetFavoriteCubit>().getFavorites(context);

        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
