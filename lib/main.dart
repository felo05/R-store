import 'package:e_commerce/cart/cubit/get_cart/cart_cubit.dart';
import 'package:e_commerce/helpers/dio_helper.dart';
import 'package:e_commerce/home/main_screen.dart';
import 'package:e_commerce/localization/cubit/languages_cubit.dart';
import 'package:e_commerce/login/login_screen.dart';
import 'package:e_commerce/onboarding/onboarding_screen.dart';
import 'package:e_commerce/orders/cubit/get_orders_cubit.dart';
import 'package:e_commerce/product_details/cubit/add_to_cart/add_to_cart_cubit.dart';
import 'package:e_commerce/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';

import 'cart/cubit/change_body/change_body_cubit.dart';
import 'cart/cubit/change_total/change_total_cubit.dart';
import 'favorites/cubit/get_favorite_cubit.dart';
import 'helpers/hive_helper.dart';
import 'home/cubits/add_favorite/add_favorite_cubit.dart';
import 'home/cubits/categories/categories_cubit.dart';
import 'home/cubits/products/products_cubit.dart';
import 'login/model/profile_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileDataAdapter());
  await Hive.openBox(HiveHelper.boxKey);
  DioHelpers.init();
  print(HiveHelper.getToken());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(
          create: (context) => GetOrdersCubit(),
        ),
        BlocProvider(
          create: (context) => ChangeTotalCubit(),
        ),
        BlocProvider(
          create: (context) => ChangeBodyCubit(),
        ),
        BlocProvider(
          create: (context) => AddFavoriteCubit(),
        ),
        BlocProvider(
            create: (context) => ProductsCubit()..getProducts()
        ),
        BlocProvider(
            create: (context) => GetFavoriteCubit()..getFavorites()
        ),
        BlocProvider(
            create: (context) => SearchCubit()
        ),
        BlocProvider(
            create: (context) => CartCubit()..getCart()
        ),
        BlocProvider(
            create: (context) => AddToCartCubit()
        ),
        BlocProvider(
          create: (context) => CategoriesCubit()..getCategories(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return GetMaterialApp(
                locale: state.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                debugShowCheckedModeBanner: false,
                home: HiveHelper.isFirstTime()
                    ? const OnboardingScreen()
                    : HiveHelper.isLoggedin()
                    ?  MainScreen(selectedIndex: 0,)
                    : LoginScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
