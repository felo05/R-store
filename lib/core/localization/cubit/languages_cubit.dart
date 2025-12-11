import 'dart:io';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../di/service_locator.dart';
import '../../services/i_storage_service.dart';

part 'languages_state.dart';

final String defaultLocale = Platform.localeName;

class LanguageCubit extends Cubit<LanguageState> {
  final IStorageService _storageService = sl<IStorageService>();

  static Locale? _locale = cachedLanguage == null
      ? defaultLocale.substring(0, 2) == 'ar'
          ? const Locale('ar', '')
          : const Locale('en', '')
      : Locale(cachedLanguage!, '');

  static String get currentLanguage => _locale!.toString();

  static String? get cachedLanguage => sl<IStorageService>().getLanguage();

  LanguageCubit()
      : super(
          SelectedLocale(
            cachedLanguage == null ? _locale! : Locale(cachedLanguage!, ''),
          ),
        ) {
    if (cachedLanguage == null) {
      _storageService.setLanguage(defaultLocale.substring(0, 2));
    }
  }

  void toArabic() {
    _storageService.setLanguage('ar');
    emit(SelectedLocale(_locale = const Locale('ar', '')));
  }

  void toEnglish() {
    _storageService.setLanguage('en');
    emit(SelectedLocale(_locale = const Locale('en', '')));
  }

  static bool get isArabic => currentLanguage == 'ar';
}
