import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/core/helpers/firebase_helper.dart';
import 'package:e_commerce/core/helpers/hive_helper.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/core/widgets/custom_text_field.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:e_commerce/features/favorites/cubit/get_favorites_cubit/get_favorite_cubit.dart';
import 'package:e_commerce/features/home/cubits/banners/banner_cubit.dart';
import 'package:e_commerce/features/home/cubits/categories/categories_cubit.dart';
import 'package:e_commerce/features/home/cubits/products/products_cubit.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:e_commerce/features/search/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/localization/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/localization/cubit/languages_cubit.dart';
import '../../core/widgets/category_card.dart';
import '../../core/widgets/horizontal_products_header.dart';
import '../cart/cubit/get_cart/cart_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageCubit langCubit = context.read<LanguageCubit>();
    final String langText = HiveHelper.getLanguage() == "en" ? "ع" : "en";
    _getData();
    return BlocProvider(
      create: (context) => ProductsCubit()..getProducts(context),
      child: RefreshIndicator(
        onRefresh: () async {
          _reloadData(context);
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height:40.h,child: Image.asset('assets/images/Logo.png')),SizedBox(width: 5.w,),
                CustomText(text: "R-Store", textSize: 22.sp, textWeight: FontWeight.bold,textColor: baseColor,)
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    langText == "en"
                        ? langCubit.toEnglish()
                        : langCubit.toArabic();
                    _reloadData(context);
                    context.read<GetFavoriteCubit>().getFavorites(context);
                    context.read<CartCubit>().getCart(context);
                  },
                  child: CustomText(
                      text: langText,
                      textSize: 24,
                      textColor: baseColor,
                      textWeight: FontWeight.bold))
            ],
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
                      onTap: () => Get.to(const SearchScreen()),
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
                  BlocConsumer<CategoriesCubit, CategoriesState>(
                    listener: (context, state) {
                      if (state is CategoriesErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      if (state is CategoriesLoadingState) {
                        return SizedBox(
                          height: 225.h,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is CategoriesSuccessState) {
                        final categories = state.categories.data?.data ?? [];
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
                                  return CategoryCard(category: category);
                                },
                              ),
                            );
                          },
                        );
                      } else if (state is CategoriesErrorState) {
                        return SizedBox(
                          height: 225.h,
                          child: Center(
                            child: CustomText(
                              text: state.message,
                              textSize: 18,
                              textColor: Colors.red,
                              textWeight: FontWeight.bold,
                            ),
                          ),
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
                    create: (context) => BannerCubit()..getBanners(context),
                    child: BlocConsumer<BannerCubit, BannerState>(
                      listener: (context, state) {
                        if (state is BannerErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMsg)));
                        }
                      },
                      builder: (context, state) {
                        if (state is BannerLoadingState) {
                          return SizedBox(
                            height: 170.h,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else if (state is BannerSuccessState) {
                          final banners = state.bannerModel.data ?? [];
                          return CarouselSlider(
                            items: banners.map((bannerItem) {
                              return SizedBox(
                                height: 150.h,
                                width: double.infinity,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.r),
                                    child: CustomNetworkImage(
                                        image: bannerItem.image ?? "")),
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
                        } else if (state is BannerErrorState) {
                          return SizedBox(
                            height: 170.h,
                            child: Center(
                              child: CustomText(
                                text: state.errorMsg,
                                textSize: 18,
                                textColor: Colors.red,
                                textWeight: FontWeight.bold,
                              ),
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
                  BlocConsumer<ProductsCubit, ProductsState>(
                    listener: (context, state) {
                      if (state is ProductsErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMsg)));
                      }
                    },
                    builder: (context, state) {
                      if (state is ProductsLoadingState) {
                        return SizedBox(
                            height: 225.h,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else if (state is ProductsSuccessState) {
                        final products = state.productData.data ?? [];
                        return SizedBox(
                          height: 250.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: products[index],
                                height: 130,
                                isInHome: true,
                                reloadAll: false,
                              );
                            },
                          ),
                        );
                      } else if (state is ProductsErrorState) {
                        return SizedBox(
                          height: 225.h,
                          child: Center(
                            child: CustomText(
                              text: state.errorMsg,
                              textSize: 18,
                              textColor: Colors.red,
                              textWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }

  void _getData() async {
    try {
      if (FirebaseHelper.currentUserId == null) return;

      final userDoc = await FirebaseHelper.firestore
          .collection(FirebaseHelper.usersCollection)
          .doc(FirebaseHelper.currentUserId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        HiveHelper.setUser(ProfileData.fromJson(userData));
      }
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          print('Error getting profile data: $e');
        }
      }
    }
  }

  void _reloadData(BuildContext context) {
    context.read<CategoriesCubit>().getCategories(context);
    context.read<ProductsCubit>().getProducts(context);
  }
}
