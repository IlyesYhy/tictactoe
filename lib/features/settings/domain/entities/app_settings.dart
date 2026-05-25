import 'package:equatable/equatable.dart';

import 'app_language.dart';
import 'app_theme_mode.dart';

final class AppSettings extends Equatable {
  const AppSettings({required this.language, required this.themeMode});

  final AppLanguage language;
  final AppThemeMode themeMode;

  AppSettings copyWith({AppLanguage? language, AppThemeMode? themeMode}) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [language, themeMode];
}
