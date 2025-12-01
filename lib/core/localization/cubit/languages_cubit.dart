import 'dart:io';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../helpers/hive_helper.dart';

part 'languages_state.dart';

final String defaultLocale = Platform.localeName;

class LanguageCubit extends Cubit<LanguageState> {
  static Locale? _locale = cachedLanguage == null
      ? defaultLocale.substring(0, 2) == 'ar'
          ? const Locale('ar', '')
          : const Locale('en', '')
      : Locale(cachedLanguage!, '');

  static String get currentLanguage => _locale!.toString();

  static String? get cachedLanguage => HiveHelper.getLanguage();

  LanguageCubit()
      : super(
          SelectedLocale(
            cachedLanguage == null ? _locale! : Locale(cachedLanguage!, ''),
          ),
        ) {
    if (cachedLanguage == null) {
      HiveHelper.setLanguage(defaultLocale.substring(0, 2));
    }
  }

  void toArabic() {
    Get.updateLocale(const Locale("ar"));
    HiveHelper.setLanguage('ar');
    emit(SelectedLocale(_locale = const Locale('ar', '')));
  }

  void toEnglish() {
    Get.updateLocale(const Locale("en"));
    HiveHelper.setLanguage('en');
    emit(SelectedLocale(_locale = const Locale('en', '')));
  }

  static bool get isArabic => currentLanguage == 'ar';
}
