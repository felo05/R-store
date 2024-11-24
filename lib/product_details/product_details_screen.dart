import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/home/cubits/add_favorite/add_favorite_cubit.dart';
import 'package:e_commerce/product_details/cubit/products_in_details/products_in_details_cubit.dart';
import 'package:e_commerce/widgets/add_to_cart_bottom_navigation.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:e_commerce/widgets/horizontal_products_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home/cubits/products/products_cubit.dart';
import '../home/models/products_model.dart';
import '../widgets/product_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductData product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    List images = product.images ?? [product.image.toString()];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  CustomText(
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
                items: images.map((images) {
                  return SizedBox(
                    height: 300.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.network(
                        images,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
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
                create: (context) => ProductsInDetailsCubit()..getProducts(),
                child:
                    BlocBuilder<ProductsInDetailsCubit, ProductsInDetailsState>(
                  builder: (context, state) {
                    if (state is ProductsLoadingState) {
                      return SizedBox(
                          height: 225.h,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    } else if (state is ProductsSuccessState) {
                      final products = context
                              .read<ProductsInDetailsCubit>()
                              .productsModel
                              .data
                              ?.data ??
                          [];
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
        context
            .read<AddFavoriteCubit>()
            .addFavorite(widget.product.id!.toInt(), context, true, true);
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
