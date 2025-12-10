import 'package:e_commerce/core/initialization/app_initializer.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/localization/cubit/languages_cubit.dart';
import 'package:e_commerce/core/localization/l10n/app_localizations.dart';
import 'package:e_commerce/features/authnetication/login/view/screens/login_screen.dart';
import 'package:e_commerce/features/cart/repository/i_cart_repository.dart';
import 'package:e_commerce/features/cart/viewmodel/get_cart/cart_cubit.dart';
import 'package:e_commerce/features/favorites/repository/i_favorites_repository.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';
import 'package:e_commerce/features/home/view/screens/main_screen.dart';
import 'package:e_commerce/features/onboarding/view/screens/onboarding_screen.dart';
import 'package:e_commerce/features/favorites/viewmodel/get_favorite_cubit.dart';
import 'package:e_commerce/features/home/viewmodel/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimating = false;
  bool _isInitialized = false;
  Widget? _appWidget;

  @override
  void initState() {
    super.initState();
    // Start animation after first frame to avoid jank
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isAnimating = true;
      });
      _initializeAndNavigate();
    });
  }

  Future<void> _initializeAndNavigate() async {
    // Use AppInitializer which runs optimized concurrent initialization
    final result = await AppInitializer.initialize();

    if (!mounted) return;

    // Handle errors
    if (result.error != null) {
      _showErrorWithRetry(result.error!);
      return;
    }

    // Add minimum display time for better UX (optional)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigate to appropriate screen based on user state
    Widget nextScreen;
    if (result.isFirstTime) {
      nextScreen = const OnboardingScreen();
    } else if (result.isLoggedIn) {
      nextScreen = const MainScreen(initialIndex: 0);
    } else {
      nextScreen = LoginScreen();
    }

    // Create GetMaterialApp with MultiBlocProvider after initialization
    final appWidget = SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<LanguageCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    ProductsCubit(sl<IHomeRepository>())..getProducts(context),
              ),
              BlocProvider(
                create: (context) =>
                    GetFavoriteCubit(sl<IFavoritesRepository>())
                      ..getFavorites(context),
              ),
              BlocProvider(
                create: (context) =>
                    CartCubit(sl<ICartRepository>())..getCart(context),
              ),
            ],
            child: BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return GetMaterialApp(
                  locale: state.locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  home: nextScreen,
                );
              },
            ),
          );
        },
      ),
    );

    // Replace the entire app
    if (mounted) {
      setState(() {
        _isInitialized = true;
        _appWidget = appWidget;
      });
    }
  }

  void _showErrorWithRetry(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error initializing app: $error'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => _initializeAndNavigate(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return the initialized app if ready
    if (_isInitialized && _appWidget != null) {
      return _appWidget!;
    }

    // Otherwise show splash screen
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with fade animation
            AnimatedOpacity(
              opacity: _isAnimating ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: AnimatedScale(
                scale: _isAnimating ? 1.0 : 0.8,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Loading indicator with delayed fade-in
            AnimatedOpacity(
              opacity: _isAnimating ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _isAnimating ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1000),
              child: const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
