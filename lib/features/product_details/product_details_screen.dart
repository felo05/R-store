import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/core//widgets/horizontal_products_header.dart';
import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/core/widgets/add_to_cart_bottom_navigation.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/features/favorites/repository/favorites_repository_implementation.dart';
import 'package:e_commerce/features/product_details/cubit/products_in_details/products_in_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/widgets/product_card.dart';
import '../home/models/products_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductData product;

  const ProductDetailsScreen({super.key, required this.product});

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
                        "${product.discount}% ${AppLocalizations.of(context)!
                            .off}",
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
                ProductsInDetailsCubit()
                  ..getProducts(context),
                child: BlocBuilder<
                    ProductsInDetailsCubit,
                    ProductsInDetailsState>(
                  builder: (context, state) {
                    if (state is ProductsInDetailsLoadingState) {
                      return SizedBox(
                          height: 225.h,
                          child:
                          const Center(child: CircularProgressIndicator()));
                    } else if (state is ProductsInDetailsSuccessState) {
                      final products = state.productsModel.data?.data ?? [];
                      return SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: products[index],
                              height: 135,
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
        FavoritesRepositoryImplementation()
            .addFavorite(widget.product.id!.toInt(), context, true, true);
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
