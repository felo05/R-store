import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/core/constants/kcolors.dart';
import 'package:e_commerce/core/constants/firebase_constants.dart';
import 'package:e_commerce/core/widgets/custom_network_image.dart';
import 'package:e_commerce/core/widgets/custom_text.dart';
import 'package:e_commerce/core/widgets/custom_text_field.dart';
import 'package:e_commerce/core/widgets/product_card.dart';
import 'package:e_commerce/core/widgets/skeleton_loaders.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce/core/localization/cubit/languages_cubit.dart';
import 'package:e_commerce/features/home/view/widgets/category_card.dart';
import 'package:e_commerce/core/widgets/horizontal_products_header.dart';
import 'package:e_commerce/features/cart/viewmodel/get_cart/cart_cubit.dart';
import 'package:e_commerce/core/routes/app_routes.dart';

import '../../../../core/services/i_storage_service.dart';
import '../../../favorites/viewmodel/get_favorite_cubit.dart';
import '../../viewmodel/banners/banner_cubit.dart';
import '../../viewmodel/categories/categories_cubit.dart';
import '../../viewmodel/products/products_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Must call super.build for AutomaticKeepAlive
    final LanguageCubit langCubit = context.read<LanguageCubit>();
    final String langText = sl<IStorageService>().getLanguage() == "en" ? "ع" : "en";
    _getData();
    // ProductsCubit is already provided in main.dart, no need to create duplicate
    return RefreshIndicator(
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
                      onTap: () => Navigator.pushNamed(context, AppRoutes.search),
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
                      text: AppLocalizations.of(context)!.categories,onPressed: ()=>Navigator.pushNamed(context, AppRoutes.categoriesList)),
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
                          height: 235.h,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.w,
                              mainAxisSpacing: 10.h,
                              childAspectRatio: 0.6,
                            ),
                            itemBuilder: (context, index) => const CategoryCardSkeleton(),
                          ),
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
                    create: (context) => BannerCubit(sl<IHomeRepository>())..getBanners(context),
                    child: BlocConsumer<BannerCubit, BannerState>(
                      listener: (context, state) {
                        if (state is BannerErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMsg)));
                        }
                      },
                      builder: (context, state) {
                        if (state is BannerLoadingState) {
                          return const BannerSkeleton(height: 170);
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
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.productsList),
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
                            height: 500.h,
                            child: const ProductGridSkeleton(itemCount: 4,isHorizontal: true,));
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
      );
  }

  void _getData() async {
    try {
      if (FirebaseConstants.currentUserId == null) return;

      final userDoc = await FirebaseConstants.firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(FirebaseConstants.currentUserId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        sl<IStorageService>().setUser(ProfileData.fromJson(userData));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting profile data: $e');
      }
    }
  }

  void _reloadData(BuildContext context) {
    context.read<CategoriesCubit>().getCategories(context);
    context.read<ProductsCubit>().getProducts(context);
  }
}
