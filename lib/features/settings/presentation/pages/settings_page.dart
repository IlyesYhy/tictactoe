import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/settings/di/settings_providers.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const _horizontalPadding = 16.0;
  static const _verticalPadding = 16.0;
  static const _sectionGap = 18.0;
  static const _cardGap = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final packageInfo = ref.watch(packageInfoProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.settingsTitle),
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          _horizontalPadding,
          _verticalPadding,
          _horizontalPadding,
          32,
        ),
        children: [
          const _PlayerCard(),
          const SizedBox(height: _sectionGap),
          _SectionHeader(label: context.l10n.settingsTheme),
          const SizedBox(height: _cardGap),
          _SettingsCard(
            padding: const EdgeInsets.all(4),
            child: _ThemeModeSelector(
              selected: settings.themeMode,
              onSelected: controller.selectThemeMode,
            ),
          ),
          const SizedBox(height: _sectionGap),
          _SectionHeader(label: context.l10n.settingsPreferences),
          const SizedBox(height: _cardGap),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsTile(
                  key: const Key('settings_language'),
                  icon: Icons.language_rounded,
                  title: context.l10n.settingsLanguage,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        settings.language.code.toUpperCase(),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  onTap: () => _showLanguagePicker(
                    context: context,
                    currentLanguage: settings.language,
                    controller: controller,
                  ),
                ),
                const _SettingsDivider(),
                SwitchListTile(
                  key: const Key('settings_haptic_feedback'),
                  secondary: Icon(
                    Icons.vibration_rounded,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(context.l10n.settingsHapticFeedback),
                  value: settings.isHapticFeedbackEnabled,
                  onChanged: (enabled) {
                    unawaited(controller.setHapticFeedback(enabled));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: _sectionGap),
          _SectionHeader(label: context.l10n.settingsAbout),
          const SizedBox(height: _cardGap),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsTile(
                  key: const Key('settings_game_rules'),
                  icon: Icons.article_outlined,
                  title: context.l10n.settingsGameRules,
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  onTap: () => context.pushNamed(AppRouteNames.gameRules),
                ),
                const _SettingsDivider(),
                _SettingsTile(
                  key: const Key('settings_version'),
                  icon: Icons.info_outline_rounded,
                  title: context.l10n.settingsVersion,
                  trailing: Text(
                    packageInfo.version,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguagePicker({
    required BuildContext context,
    required AppLanguage currentLanguage,
    required SettingsController controller,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: RadioGroup<AppLanguage>(
            groupValue: currentLanguage,
            onChanged: (selected) {
              if (selected == null) return;

              unawaited(controller.selectLanguage(selected));
              Navigator.of(context).pop();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final language in AppLanguage.values)
                  RadioListTile<AppLanguage>(
                    key: Key('settings_language_${language.code}'),
                    title: Text(_languageLabel(context.l10n, language)),
                    value: language,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard();

  static const _robotSize = 92.0;
  static const _lightRobotAssetPath = 'assets/bot-light-settings.png';
  static const _darkRobotAssetPath = 'assets/bot-dark-settings.png';

  String _robotAssetPath(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? _darkRobotAssetPath : _lightRobotAssetPath;
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          SizedBox(
            width: _robotSize,
            height: _robotSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 2,
                  top: 16,
                  child: _Sparkle(
                    color: context.colorScheme.primary.withValues(alpha: 0.22),
                    size: 14,
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 18,
                  child: _Sparkle(
                    color: context.colorScheme.secondary.withValues(
                      alpha: 0.22,
                    ),
                    size: 14,
                  ),
                ),
                Image.asset(
                  _robotAssetPath(context),
                  width: 82,
                  height: 82,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.settingsPlayer,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.settingsPlayerSubtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _PlayerInfoRow(
                  label: context.l10n.settingsPlayerName,
                  value: context.l10n.you,
                ),
                const SizedBox(height: 8),
                _PlayerInfoRow(
                  label: context.l10n.settingsPreferredSymbol,
                  valueWidget: Text(
                    'X',
                    textScaler: TextScaler.noScaling,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerInfoRow extends StatelessWidget {
  const _PlayerInfoRow({required this.label, this.value, this.valueWidget})
    : assert(value != null || valueWidget != null);

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        valueWidget ??
            Text(
              value!,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
      ],
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.selected, required this.onSelected});

  final AppThemeMode selected;
  final ValueChanged<AppThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final themeMode in AppThemeMode.values)
          Expanded(
            child: _ThemeModeButton(
              key: Key('settings_theme_${themeMode.name}'),
              themeMode: themeMode,
              isSelected: selected == themeMode,
              onTap: () => onSelected(themeMode),
            ),
          ),
      ],
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton({
    required this.themeMode,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AppThemeMode themeMode;
  final bool isSelected;
  final VoidCallback onTap;

  static const _height = 44.0;
  static const _radius = 12.0;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected
        ? context.colorScheme.onPrimary
        : context.colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: _height,
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(_radius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_themeIcon(themeMode), size: 18, color: foreground),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _themeLabel(context.l10n, themeMode),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _themeIcon(AppThemeMode themeMode) {
    return switch (themeMode) {
      AppThemeMode.light => Icons.light_mode_outlined,
      AppThemeMode.dark => Icons.dark_mode_outlined,
      AppThemeMode.system => Icons.phone_iphone_rounded,
    };
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsetsGeometry padding;

  static const _radius = 18.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  static const _horizontalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
      ),
      leading: Icon(
        icon,
        size: 20,
        color: context.colorScheme.onSurfaceVariant,
      ),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 52,
      color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: context.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome_rounded, color: color, size: size);
  }
}

String _languageLabel(AppLocalizations l10n, AppLanguage language) {
  return switch (language) {
    AppLanguage.en => l10n.settingsLanguageEnglish,
    AppLanguage.fr => l10n.settingsLanguageFrench,
  };
}

String _themeLabel(AppLocalizations l10n, AppThemeMode themeMode) {
  return switch (themeMode) {
    AppThemeMode.light => l10n.settingsThemeLight,
    AppThemeMode.dark => l10n.settingsThemeDark,
    AppThemeMode.system => l10n.settingsThemeSystem,
  };
}
