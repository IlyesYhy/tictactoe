import 'dart:ui';

import '../../domain/entities/app_language.dart';

/// Maps the domain [AppLanguage] to a Flutter [Locale].
///
/// Kept in the presentation layer so the domain entity stays Flutter-independent.
extension AppLanguageLocaleX on AppLanguage {
  Locale toLocale() => Locale(code);
}
