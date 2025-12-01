import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get already_have_an_account;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @create_new_account.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get create_new_account;

  /// No description provided for @email_not_valid.
  ///
  /// In en, this message translates to:
  /// **'Email not valid'**
  String get email_not_valid;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @password_check.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get password_check;

  /// No description provided for @check_password.
  ///
  /// In en, this message translates to:
  /// **'Check password'**
  String get check_password;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @phone_number_not_valid.
  ///
  /// In en, this message translates to:
  /// **'Phone number not valid'**
  String get phone_number_not_valid;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enter_valid_name.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get enter_valid_name;

  /// No description provided for @set_up_your_username_and_password.
  ///
  /// In en, this message translates to:
  /// **'Set up your username and password,\nyou can always change it later.'**
  String get set_up_your_username_and_password;

  /// No description provided for @password_has_to_be_more_than.
  ///
  /// In en, this message translates to:
  /// **'Password has to be more than 5 letters'**
  String get password_has_to_be_more_than;

  /// No description provided for @buy_groceries_easily.
  ///
  /// In en, this message translates to:
  /// **'Buy Groceries Easily\nwith Us'**
  String get buy_groceries_easily;

  /// No description provided for @we_deliver_grocery.
  ///
  /// In en, this message translates to:
  /// **'We Deliver Grocery\nat Your Doorstep'**
  String get we_deliver_grocery;

  /// No description provided for @all_your_home_needs.
  ///
  /// In en, this message translates to:
  /// **'All Your Home Needs\nare Here'**
  String get all_your_home_needs;

  /// No description provided for @did_not_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t have an account? '**
  String get did_not_have_an_account;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgot_password;

  /// No description provided for @email_or_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get email_or_phone_number;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @invalid_email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'invalid Email or Phone'**
  String get invalid_email_or_phone;

  /// No description provided for @log_in_to_your_account.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account using your email\nor your phone number'**
  String get log_in_to_your_account;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @similar_products.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get similar_products;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **' 4.0 (146 reviews)'**
  String get reviews;

  /// No description provided for @shopping_cart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shopping_cart;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get old_password;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @favorite_products.
  ///
  /// In en, this message translates to:
  /// **'Favorite products'**
  String get favorite_products;

  /// No description provided for @session_ended.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get session_ended;

  /// No description provided for @no_favorite_products_added_yet.
  ///
  /// In en, this message translates to:
  /// **'No favorite products added yet'**
  String get no_favorite_products_added_yet;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @best_deals.
  ///
  /// In en, this message translates to:
  /// **'Best Deals'**
  String get best_deals;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @see_more.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get see_more;

  /// No description provided for @see_less.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get see_less;

  /// No description provided for @go_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Go to cart'**
  String get go_to_cart;

  /// No description provided for @no_products_added_to_cart_yet.
  ///
  /// In en, this message translates to:
  /// **'No products added to cart yet'**
  String get no_products_added_to_cart_yet;

  /// No description provided for @add_address.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get add_address;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get note;

  /// No description provided for @it_cant_be_empty.
  ///
  /// In en, this message translates to:
  /// **'It can\'t be empty'**
  String get it_cant_be_empty;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @error_getting_current_location.
  ///
  /// In en, this message translates to:
  /// **'Error getting current location'**
  String get error_getting_current_location;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @confirm_location.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirm_location;

  /// No description provided for @current_location.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get current_location;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total: '**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @your_cart.
  ///
  /// In en, this message translates to:
  /// **'Your Cart'**
  String get your_cart;

  /// No description provided for @total_cost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get total_cost;

  /// No description provided for @please_select_an_address.
  ///
  /// In en, this message translates to:
  /// **'Please select an address'**
  String get please_select_an_address;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @please_select_a_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get please_select_a_payment_method;

  /// No description provided for @credit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get credit_card;

  /// No description provided for @cash_on_delivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cash_on_delivery;

  /// No description provided for @add_new_address.
  ///
  /// In en, this message translates to:
  /// **'Add New Address  '**
  String get add_new_address;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty: '**
  String get qty;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @it_is_a_long_established.
  ///
  /// In en, this message translates to:
  /// **'It is a long established fact that a reader\nwill be distracted by the readable.'**
  String get it_is_a_long_established;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @no_orders_available.
  ///
  /// In en, this message translates to:
  /// **'No orders available'**
  String get no_orders_available;

  /// No description provided for @order_id.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get order_id;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @no_address_provided.
  ///
  /// In en, this message translates to:
  /// **'No address provided'**
  String get no_address_provided;

  /// No description provided for @no_order_details.
  ///
  /// In en, this message translates to:
  /// **'No order details available.'**
  String get no_order_details;

  /// No description provided for @failed_to_load_order.
  ///
  /// In en, this message translates to:
  /// **'Failed to load order details.'**
  String get failed_to_load_order;

  /// No description provided for @my_orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get my_orders;

  /// No description provided for @no_products_found.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get no_products_found;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @password_changed.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed;

  /// No description provided for @connection_timeout_with_the_server.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout with the server.'**
  String get connection_timeout_with_the_server;

  /// No description provided for @send_timeout_with_the_server.
  ///
  /// In en, this message translates to:
  /// **'Send timeout with the server.'**
  String get send_timeout_with_the_server;

  /// No description provided for @receive_timeout_with_the_server.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout with the server.'**
  String get receive_timeout_with_the_server;

  /// No description provided for @request_to_the_server_was_canceled.
  ///
  /// In en, this message translates to:
  /// **'Request to the server was canceled.'**
  String get request_to_the_server_was_canceled;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @unexpected_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again!'**
  String get unexpected_error_occurred;

  /// No description provided for @authentication_or_authorization_error.
  ///
  /// In en, this message translates to:
  /// **'Authentication or authorization error. Please try again.'**
  String get authentication_or_authorization_error;

  /// No description provided for @the_requested_resource_was_not_found.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get the_requested_resource_was_not_found;

  /// No description provided for @internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal server error. Please try again later.'**
  String get internal_server_error;

  /// No description provided for @please_select_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please select all fields'**
  String get please_select_all_fields;

  /// No description provided for @delivery_address.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get delivery_address;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
