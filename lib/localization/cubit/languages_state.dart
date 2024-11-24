part of 'languages_cubit.dart';

@immutable
abstract class LanguageState {
  final Locale locale;
  const LanguageState(this.locale);
}

class SelectedLocale extends LanguageState {
  const SelectedLocale(Locale locale) : super(locale);
}
