import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/helpers/dio_helper.dart';
import 'core/helpers/hive_helper.dart';
import 'core/localization/cubit/languages_cubit.dart';
import 'features/authnetication/login_screen.dart';
import 'features/cart/cubit/get_cart/cart_cubit.dart';
import 'features/favorites/cubit/get_favorites_cubit/get_favorite_cubit.dart';
import 'features/home/cubits/products/products_cubit.dart';
import 'features/home/main_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/product_details/cubit/add_to_cart/add_to_cart_cubit.dart';

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
            create: (context) => ProductsCubit()..getProducts(context)
        ),
        BlocProvider(
            create: (context) => GetFavoriteCubit()..getFavorites(context)
        ),
        BlocProvider(
            create: (context) => CartCubit()..getCart(context)
        ),
        BlocProvider(
            create: (context) => AddToCartCubit()
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
                        ? const MainScreen(
                            initialIndex: 0,
                          )
                        : LoginScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
