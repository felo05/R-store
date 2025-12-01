import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/helpers/hive_helper.dart';
import 'core/localization/cubit/languages_cubit.dart';
import 'core/localization/l10n/app_localizations.dart';
import 'features/authnetication/login_screen.dart';
import 'features/cart/cubit/get_cart/cart_cubit.dart';
import 'features/favorites/cubit/get_favorites_cubit/get_favorite_cubit.dart';
import 'features/home/cubits/products/products_cubit.dart';
import 'features/home/main_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/product_details/cubit/add_to_cart/add_to_cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization error: $e');
    debugPrint('');
    debugPrint('═══════════════════════════════════════');
    debugPrint('To fix this, run these commands:');
    debugPrint('  1. npm install -g firebase-tools');
    debugPrint('  2. dart pub global activate flutterfire_cli');
    debugPrint('  3. firebase login');
    debugPrint('  4. flutterfire configure');
    debugPrint('');
    debugPrint('Or see QUICK_START.md for detailed instructions');
    debugPrint('═══════════════════════════════════════');
  }

  await Hive.initFlutter();
  Hive.registerAdapter(ProfileDataAdapter());

  // Try to open box, if error occurs due to type mismatch, delete and recreate
  try {
    await Hive.openBox(HiveHelper.boxKey);
  } catch (e) {
    debugPrint('Error opening Hive box: $e');
    debugPrint('Clearing Hive storage due to schema change...');
    try {
      await Hive.deleteBoxFromDisk(HiveHelper.boxKey);
      await Hive.openBox(HiveHelper.boxKey);
      debugPrint('✅ Hive storage cleared and recreated');
    } catch (e2) {
      debugPrint('Failed to clear Hive storage: $e2');
    }
  }

  runApp(MyApp(firebaseInitialized: firebaseInitialized));
}

class MyApp extends StatelessWidget {
  final bool firebaseInitialized;

  const MyApp({super.key, this.firebaseInitialized = false});

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
      child: SafeArea(
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
                  home: !firebaseInitialized
                      ? _FirebaseSetupScreen()
                      : HiveHelper.isFirstTime()
                          ? const OnboardingScreen()
                          : HiveHelper.isLoggedin()
                              ? const MainScreen(initialIndex: 0)
                              : LoginScreen(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FirebaseSetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                'Firebase Not Configured',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please configure Firebase to use this app.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Setup:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. npm install -g firebase-tools'),
                    Text('2. dart pub global activate flutterfire_cli'),
                    Text('3. firebase login'),
                    Text('4. flutterfire configure'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'See QUICK_START.md for detailed instructions',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
