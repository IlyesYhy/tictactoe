import 'package:equatable/equatable.dart';

import 'app_language.dart';
import 'app_theme_mode.dart';

final class AppSettings extends Equatable {
  const AppSettings({
    required this.language,
    required this.themeMode,
    this.isHapticFeedbackEnabled = true,
  });

  final AppLanguage language;
  final AppThemeMode themeMode;
  final bool isHapticFeedbackEnabled;

  AppSettings copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
    bool? isHapticFeedbackEnabled,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      isHapticFeedbackEnabled:
          isHapticFeedbackEnabled ?? this.isHapticFeedbackEnabled,
    );
  }

  @override
  List<Object?> get props => [language, themeMode, isHapticFeedbackEnabled];
}
