import 'package:get_it/get_it.dart';
import 'package:e_commerce/core/localization/cubit/languages_cubit.dart';
import 'package:e_commerce/features/home/repository/i_home_repository.dart';
import 'package:e_commerce/features/home/repository/home_repository.dart';
import 'package:e_commerce/features/favorites/repository/i_favorites_repository.dart';
import 'package:e_commerce/features/favorites/repository/favorites_repository.dart';
import 'package:e_commerce/features/cart/repository/i_cart_repository.dart';
import 'package:e_commerce/features/cart/repository/cart_repository.dart';
import 'package:e_commerce/features/product_details/repository/i_product_details_repository.dart';
import 'package:e_commerce/features/product_details/repository/product_details_repository.dart';
import 'package:e_commerce/features/profile/repository/i_logout_repository.dart';
import 'package:e_commerce/features/profile/repository/logout_repository.dart';
import 'package:e_commerce/features/edit_profile/repository/i_edit_profile_repository.dart';
import 'package:e_commerce/features/edit_profile/repository/edit_profile_repository.dart';
import 'package:e_commerce/features/change_password/repository/i_change_password_repository.dart';
import 'package:e_commerce/features/change_password/repository/change_password_repository.dart';
import 'package:e_commerce/features/orders/repository/i_orders_repository.dart';
import 'package:e_commerce/features/orders/repository/orders_repository.dart';
import 'package:e_commerce/features/checkout/repository/i_checkout_repository.dart';
import 'package:e_commerce/features/checkout/repository/checkout_repository.dart';
import 'package:e_commerce/features/search/repository/i_search_repository.dart';
import 'package:e_commerce/features/search/repository/search_repository.dart';
import 'package:e_commerce/features/faqs/repository/i_faqs_repository.dart';
import 'package:e_commerce/features/faqs/repository/faqs_repository.dart';
import 'package:e_commerce/features/authnetication/repository/i_authentication_repository.dart';
import 'package:e_commerce/features/authnetication/repository/authentication_repository.dart';

import '../../features/add_address/repository/i_add_address_repository.dart';
import '../../features/add_address/repository/add_address_repository.dart';
import '../../features/categories/repository/categories_repository.dart';
import '../../features/categories/repository/i_categories_repository.dart';
import '../../features/products_list/repository/i_product_list_repository.dart';
import '../../features/products_list/repository/product_list_repository.dart';
import '../../core/services/i_storage_service.dart';
import '../../core/services/storage_service.dart';
import '../services/error_handler_service.dart';
import '../services/i_error_handler_service.dart';
import '../services/i_product_status_service.dart';
import '../services/product_status_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ==================== Core Services ====================

  // Storage Service - Singleton
  sl.registerLazySingleton<IStorageService>(() => StorageService());

  // Error Handler Service - Singleton
  sl.registerLazySingleton<IErrorHandlerService>(() => ErrorHandlerService());

  // Product Status Service - Singleton
  sl.registerLazySingleton<IProductStatusService>(() => ProductStatusService());

  // Language Cubit - Singleton
  sl.registerLazySingleton<LanguageCubit>(() => LanguageCubit());

  // ==================== Repositories ====================

  // Home Repository
  sl.registerLazySingleton<IHomeRepository>(
        () => HomeRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // Favorites Repository
  sl.registerLazySingleton<IFavoritesRepository>(
        () => FavoritesRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // Product Details Repository
  sl.registerLazySingleton<IProductDetailsRepository>(
        () => ProductDetailsRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // Cart Repository
  sl.registerLazySingleton<ICartRepository>(
        () => CartRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // Authentication Repository
  sl.registerLazySingleton<IAuthenticationRepository>(
        () =>
        AuthenticationRepository(
            sl<IStorageService>(), sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // Logout Repository
  sl.registerLazySingleton<ILogoutRepository>(
        () =>
        LogoutRepository(sl<IStorageService>(), sl<IErrorHandlerService>()),
  );

  // Edit Profile Repository
  sl.registerLazySingleton<IEditProfileRepository>(
        () =>
        EditProfileRepository(
            sl<IStorageService>(), sl<IErrorHandlerService>()),
  );

  // Change Password Repository
  sl.registerLazySingleton<IChangePasswordRepository>(
        () => ChangePasswordRepository(sl<IErrorHandlerService>()),
  );

  // Orders Repository
  sl.registerLazySingleton<IOrdersRepository>(
        () => OrdersRepository(sl<IErrorHandlerService>()),
  );

  // Checkout Repository
  sl.registerLazySingleton<ICheckoutRepository>(
        () => CheckoutRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // Search Repository
  sl.registerLazySingleton<ISearchRepository>(
        () => SearchRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // FAQs Repository
  sl.registerLazySingleton<IFAQSRepository>(
        () => FAQSRepository(sl<IErrorHandlerService>()),
  );

  // Category Products Repository
  sl.registerLazySingleton<ICategoriesRepository>(
        () => CategoriesRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

  // Add Address Repository
  sl.registerLazySingleton<IAddAddressRepository>(
        () => AddAddressRepository(sl<IErrorHandlerService>()),
  );

  // Products List Repository
  sl.registerLazySingleton<IProductsListRepository>(
        () => ProductsListRepository(sl<IErrorHandlerService>(), sl<IProductStatusService>()),
  );

}