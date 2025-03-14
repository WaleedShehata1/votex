// ignore_for_file: constant_identifier_names

import '../model/language_model.dart';

bool useFiltter = false;

String? shareLink;

class AppConstants {
  static const String appName = 'Votex';
  static const double appVersion = 1.0;

  static const String fontFamily = 'Almarai';
  static const String FirstLog = 'FirstLog';
  static const String ISLOGIN = 'ISLOGIN';

  // Shared Key
  static const String THEME = 'votex_theme';
  static const String TOKEN = 'votex_token';
  static const String COUNTRY_CODE = 'votexCountry_code';
  static const String LANGUAGE_CODE = 'votexLanguage_code';

  static List<LanguageModel> languages = [
    LanguageModel(languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(
        languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}
