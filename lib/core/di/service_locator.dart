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
import '../../features/category_products/repository/i_category_products_repository.dart';
import '../../features/category_products/repository/category_products_repository.dart';
import '../../core/services/i_storage_service.dart';
import '../../core/services/storage_service.dart';
import '../services/error_handler_service.dart';
import '../services/i_error_handler_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // ==================== Core Services ====================

  // Storage Service - Singleton (returns the same instance)
  sl.registerLazySingleton<IStorageService>(() => StorageService());

  // Error Handler Service - Singleton
  sl.registerLazySingleton<IErrorHandlerService>(() => ErrorHandlerService());

  // Language Cubit - Singleton
  sl.registerLazySingleton<LanguageCubit>(() => LanguageCubit());

  // ==================== Repositories ====================

  // Home Repository
  sl.registerLazySingleton<IHomeRepository>(
        () => HomeRepository(sl<IErrorHandlerService>()),
  );

  // Favorites Repository
  sl.registerLazySingleton<IFavoritesRepository>(
        () => FavoritesRepository(sl<IErrorHandlerService>()),
  );

  // Product Details Repository
  sl.registerLazySingleton<IProductDetailsRepository>(
        () => ProductDetailsRepository(sl<IErrorHandlerService>()),
  );

  // Cart Repository
  sl.registerLazySingleton<ICartRepository>(
        () => CartRepository(sl<IErrorHandlerService>()),
  );

  // Authentication Repository
  sl.registerLazySingleton<IAuthenticationRepository>(
        () =>
        AuthenticationRepository(
            sl<IStorageService>(), sl<IErrorHandlerService>()),
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
        () => CheckoutRepository(sl<IErrorHandlerService>()),
  );

  // Search Repository
  sl.registerLazySingleton<ISearchRepository>(
        () => SearchRepository(sl<IErrorHandlerService>()),
  );

  // FAQs Repository
  sl.registerLazySingleton<IFAQSRepository>(
        () => FAQSRepository(sl<IErrorHandlerService>()),
  );

  // Category Products Repository
  sl.registerLazySingleton<ICategoryProductsRepository>(
        () => CategoryProductsRepository(sl<IErrorHandlerService>()),
  );

  // Add Address Repository
  sl.registerLazySingleton<IAddAddressRepository>(
        () => AddAddressRepository(sl<IErrorHandlerService>()),
  );

}