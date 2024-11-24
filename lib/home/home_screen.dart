import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/constants/kcolors.dart';
import 'package:e_commerce/home/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/home/cubits/categories/categories_cubit.dart';
import 'package:e_commerce/home/cubits/products/products_cubit.dart';
import 'package:e_commerce/login/model/profile_model.dart';
import 'package:e_commerce/products_list/products_list_screen.dart';
import 'package:e_commerce/search/search_screen.dart';
import 'package:e_commerce/widgets/custom_text.dart';
import 'package:e_commerce/widgets/horizontal_products_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constants/kapi.dart';
import '../helpers/dio_helper.dart';
import '../helpers/hive_helper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _getData();
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CategoriesCubit>().getCategories();
        context.read<ProductsCubit>().getProducts();
        context.read<BannerCubit>().getBanners();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leadingWidth: double.infinity,
          leading: Row(
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 26.r,
                icon: const Icon(Icons.fmd_good_outlined),
                color: baseColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: AppLocalizations.of(context)!.home,
                        textColor: Colors.black87,
                        textSize: 16,
                        textWeight: FontWeight.w400,
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                  CustomText(
                    text: AppLocalizations.of(context)!.home_address,
                    textWeight: FontWeight.w300,
                    textSize: 14,
                    textColor: const Color(0xffB5BBB6),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            child: Column(
              children: [
                Container(
                  color: backgroundColor,
                  child: InkWell(
                    onTap: () {
                      Get.to( const SearchScreen());
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 8.w, top: 5.h, left: 8.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              prefixIcon: CupertinoIcons.search,
                              text: AppLocalizations.of(context)!.search,
                              isEnabled: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                HorizontalProductsHeader(
                    text: AppLocalizations.of(context)!.categories),
                BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    if (state is CategoriesLoadingState) {
                      return SizedBox(
                        height: 225.h,
                        child:
                            const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is CategoriesSuccessState) {
                      final categories = context
                              .read<CategoriesCubit>()
                              .categoriesModel
                              .data
                              ?.data ??
                          [];

                      return OrientationBuilder(
                        builder: (context, orientation) {
                          int crossAxisCount =
                              orientation == Orientation.portrait ? 2 : 4;

                          return SizedBox(
                            height: orientation == Orientation.portrait
                                ? 235.h
                                : 500.h,
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 0.6,
                              ),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(ProductListScreen(
                                        title: category.name!,
                                        categoryID: category.id!.toInt()));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.r),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w, vertical: 5.h),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                category.image ?? "",
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context,
                                                    child, loadingProgress) {
                                                  if (loadingProgress ==
                                                      null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Center(
                                                      child:
                                                          Icon(Icons.error));
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            CustomText(
                                              text: category.name ?? '',
                                              textSize: 14,
                                              textWeight: FontWeight.bold,
                                              textColor: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                // Banner slider
                BlocProvider(
                  create: (context) => BannerCubit()..getBanners(),
                  child: BlocBuilder<BannerCubit, BannerState>(
                    builder: (context, state) {
                      if (state is BannerLoadingState) {
                        return SizedBox(
                          height: 170.h,
                          child: const Center(
                              child: CircularProgressIndicator()),
                        );
                      } else if (state is BannerSuccessState) {
                        final banners =
                            context.read<BannerCubit>().bannerModel.data ??
                                [];
                        return CarouselSlider(
                          items: banners.map((bannerItem) {
                            return SizedBox(
                              height: 150.h,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: Image.network(
                                  bannerItem.image ?? "",
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Icon(Icons.error));
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 170.h,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 850),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                // Best deals header
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
                  child: HorizontalProductsHeader(
                    text: AppLocalizations.of(context)!.best_deals,
                  ),
                ),
                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoadingState) {
                      return SizedBox(
                          height: 225.h,
                          child: const Center(
                              child: CircularProgressIndicator()));
                    } else if (state is ProductsSuccessState) {
                      final products = context
                              .read<ProductsCubit>()
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
                              reloadAll: false,
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
        ),
      ),
    );
  }

  void _getData() async {
    final response = await DioHelpers.getData(path: Kapi.profile);
    response.data["status"]
        ? HiveHelper.setUser(ProfileData.fromJson(response.data["data"]))
        : null;
  }
}
