import 'dart:ui';

import '../../domain/entities/app_language.dart';

extension AppLanguageLocaleX on AppLanguage {
  Locale toLocale() => Locale(code);
}
