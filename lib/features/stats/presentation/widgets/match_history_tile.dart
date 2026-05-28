import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

/// Single row of the match history list.
///
/// Renders the outcome, difficulty and a locale-aware relative or absolute
/// date label. [now] is injected so the relative labels stay deterministic in
/// tests.
class MatchHistoryTile extends StatelessWidget {
  const MatchHistoryTile({required this.match, required this.now, super.key});

  final CompletedMatch match;
  final DateTime now;

  static const _radius = 14.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const _iconBubbleSize = 36.0;
  static const _iconSize = 22.0;
  static const _iconLabelGap = 12.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = _outcomeColor(context, match.outcome);
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Material(
      color: context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            SizedBox(
              width: _iconBubbleSize,
              height: _iconBubbleSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _outcomeIcon(match.outcome),
                  color: color,
                  size: _iconSize,
                ),
              ),
            ),
            const SizedBox(width: _iconLabelGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _outcomeLabel(l10n, match.outcome),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _difficultyLabel(l10n, match.difficulty),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _dateLabel(l10n, locale, match.playedAt, now),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _outcomeColor(BuildContext context, MatchOutcome outcome) {
    return switch (outcome) {
      MatchOutcome.humanWon => context.colorScheme.primary,
      MatchOutcome.cpuWon => context.colorScheme.error,
      MatchOutcome.draw => context.colorScheme.onSurfaceVariant,
    };
  }

  IconData _outcomeIcon(MatchOutcome outcome) {
    return switch (outcome) {
      MatchOutcome.humanWon => Icons.emoji_events_outlined,
      MatchOutcome.cpuWon => Icons.close_rounded,
      MatchOutcome.draw => Icons.handshake_outlined,
    };
  }

  String _outcomeLabel(AppLocalizations l10n, MatchOutcome outcome) {
    return switch (outcome) {
      MatchOutcome.humanWon => l10n.matchOutcomeVictory,
      MatchOutcome.cpuWon => l10n.matchOutcomeDefeat,
      MatchOutcome.draw => l10n.matchOutcomeDraw,
    };
  }

  String _difficultyLabel(AppLocalizations l10n, GameDifficulty difficulty) {
    return switch (difficulty) {
      GameDifficulty.easy => l10n.difficultyEasy,
      GameDifficulty.hard => l10n.difficultyHard,
    };
  }

  String _dateLabel(
    AppLocalizations l10n,
    String locale,
    DateTime playedAt,
    DateTime now,
  ) {
    final playedAtDay = DateTime(playedAt.year, playedAt.month, playedAt.day);
    final today = DateTime(now.year, now.month, now.day);
    final dayDiff = today.difference(playedAtDay).inDays;

    final time = DateFormat.Hm(locale).format(playedAt);

    if (dayDiff == 0) {
      return '${l10n.statsHistoryToday}, $time';
    }
    if (dayDiff == 1) {
      return '${l10n.statsHistoryYesterday}, $time';
    }
    if (playedAt.year == now.year) {
      return DateFormat.MMMd(locale).format(playedAt);
    }
    return DateFormat.yMMMd(locale).format(playedAt);
  }
}
