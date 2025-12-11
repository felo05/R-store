import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/features/authnetication/login/view/screens/login_screen.dart';
import 'package:e_commerce/features/authnetication/register/view/screens/register_screen.dart';
import 'package:e_commerce/features/home/view/screens/home_screen.dart';
import 'package:e_commerce/features/product_details/view/screens/product_details_screen.dart';
import 'package:e_commerce/features/categories/view/screens/categories_list_screen.dart';
import 'package:e_commerce/features/categories/view/screens/category_products_screen.dart';
import 'package:e_commerce/features/products_list/view/screen/products_list_screen.dart';
import 'package:e_commerce/features/search/view/screens/search_screen.dart';
import 'package:e_commerce/features/orders/view/screens/orders_screen.dart';
import 'package:e_commerce/features/faqs/view/screens/faqs_screen.dart';
import 'package:e_commerce/features/cart/view/screens/cart_screen.dart';
import 'package:e_commerce/features/edit_profile/view/screens/edit_profile_screen.dart';
import 'package:e_commerce/features/change_password/view/screens/change_password_screen.dart';
import 'package:e_commerce/features/add_address/view/screens/complete_adding.dart';
import 'package:e_commerce/features/add_address/view/screens/map_screen.dart';
import 'package:e_commerce/features/checkout/view/screens/checkout_screen.dart';
import 'package:e_commerce/features/home/models/products_model.dart';
import 'package:e_commerce/features/cart/model/cart_model.dart';
import 'package:e_commerce/features/profile/model/profile_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/features/orders/repository/i_orders_repository.dart';
import 'package:e_commerce/features/orders/viewmodel/get_orders_cubit.dart';
import 'package:e_commerce/features/products_list/repository/i_product_list_repository.dart';
import 'package:e_commerce/features/products_list/viewmodel/products_list_cubit.dart';

/// Centralized route management for the app
class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String productDetails = '/product-details';
  static const String categoriesList = '/categories-list';
  static const String categoryProducts = '/category-products';
  static const String productsList = '/products-list';
  static const String search = '/search';
  static const String orders = '/orders';
  static const String faqs = '/faqs';
  static const String cart = '/cart';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String completeAddAddress = '/complete-add-address';
  static const String mapScreen = '/map-screen';
  static const String checkout = '/checkout';

  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) =>  RegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) =>  const HomeScreen());

      case productDetails:
        final args = settings.arguments as ProductDetailsArguments?;
        if (args == null) {
          return _errorRoute('Product details arguments are required');
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(
            product: args.product,
            productId: args.productId,
          ),
        );

      case categoriesList:
        return MaterialPageRoute(builder: (_) => const CategoriesListScreen());

      case categoryProducts:
        final args = settings.arguments as CategoryProductsArguments?;
        if (args == null) {
          return _errorRoute('Category products arguments are required');
        }
        return MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(
            title: args.categoryName,
            categoryID: args.categoryId,
          ),
        );

      case productsList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProductsListCubit(sl<IProductsListRepository>())
              ..getProducts(context),
            child: const ProductsListScreen(),
          ),
        );

      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case orders:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => GetOrdersCubit(sl<IOrdersRepository>()),
            child:  const OrderScreen(),
          ),
        );

      case faqs:
        return MaterialPageRoute(builder: (_) => const FAQSScreen());

      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case editProfile:
        final args = settings.arguments as EditProfileArguments?;
        if (args == null) {
          return _errorRoute('Edit profile arguments are required');
        }
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(user: args.user),
        );

      case changePassword:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());

      case completeAddAddress:
        final args = settings.arguments as CompleteAddAddressArguments?;
        if (args == null) {
          return _errorRoute('Complete add address arguments are required');
        }
        return MaterialPageRoute(
          builder: (_) => CompleteAddAddress(
            position: args.position,
          ),
        );

      case mapScreen:
        return MaterialPageRoute(builder: (_) => const LocationPickerScreen());

      case checkout:
        final args = settings.arguments as CheckoutArguments?;
        if (args == null) {
          return _errorRoute('Checkout arguments are required');
        }
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(products: args.products),
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Error route for undefined routes
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}

/// Arguments for ProductDetailsScreen
class ProductDetailsArguments {
  final ProductData? product;
  final String? productId;

  ProductDetailsArguments({
    this.product,
    this.productId,
  }) : assert(product != null || productId != null,
            'Either product or productId must be provided');
}

/// Arguments for CategoryProductsScreen
class CategoryProductsArguments {
  final int categoryId;
  final String categoryName;

  CategoryProductsArguments({
    required this.categoryId,
    required this.categoryName,
  });
}

/// Arguments for EditProfileScreen
class EditProfileArguments {
  final ProfileData user;

  EditProfileArguments({required this.user});
}

/// Arguments for CompleteAddAddress
class CompleteAddAddressArguments {
  final LatLng position;

  CompleteAddAddressArguments({
    required this.position,
  });
}

/// Arguments for CheckoutScreen
class CheckoutArguments {
  final CartData products;

  CheckoutArguments({required this.products});
}


