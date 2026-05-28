import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/domain/entities/game_difficulty.dart';
import '../../domain/entities/completed_match.dart';
import '../../domain/entities/match_history.dart';
import '../../domain/entities/match_outcome.dart';
import '../../domain/repositories/stats_repository.dart';

/// Persists the match history (and the statistics derived from it) in local
/// device storage via [SharedPreferences].
///
/// Writes are serialized so two concurrent record calls cannot interleave their
/// read-modify-write and silently drop a match.
final class LocalStatsRepository implements StatsRepository {
  LocalStatsRepository(this._preferences);

  final SharedPreferences _preferences;

  // Serializes writes so concurrent record calls cannot drop an entry: each
  // recordMatch runs its read-modify-write only after the previous write has
  // completed.
  Future<void> _writeChain = Future<void>.value();

  static const _matchHistoryKey = 'stats.match_history';

  @override
  Future<MatchHistory> getMatchHistory() async {
    final encoded = _preferences.getString(_matchHistoryKey);
    if (encoded == null) return MatchHistory.empty();

    final decoded = _safeDecodeList(encoded);
    if (decoded == null) return MatchHistory.empty();

    final matches = <CompletedMatch>[];
    for (final entry in decoded) {
      if (entry is! Map<String, dynamic>) continue;
      final match = _fromMap(entry);
      if (match != null) matches.add(match);
    }
    return MatchHistory(matches);
  }

  @override
  Future<void> recordMatch(CompletedMatch match) {
    final write = _writeChain.then((_) => _appendMatch(match));
    // Keep the chain healthy after a failed write, while still surfacing the
    // error to this caller through the returned future.
    _writeChain = write.catchError((_) {});
    return write;
  }

  Future<void> _appendMatch(CompletedMatch match) async {
    final current = await getMatchHistory();
    final updated = [...current.matches, match];
    final encoded = jsonEncode(updated.map(_toMap).toList());
    await _preferences.setString(_matchHistoryKey, encoded);
  }

  List<dynamic>? _safeDecodeList(String encoded) {
    try {
      final decoded = jsonDecode(encoded);
      return decoded is List ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  // This JSON shape is private to this local repository. A dedicated data model
  // would be introduced if the format became remote, shared, versioned, or
  // structurally different from the domain entity.

  Map<String, dynamic> _toMap(CompletedMatch match) {
    return {
      'outcome': match.outcome.name,
      'difficulty': match.difficulty.name,
      'playedAt': match.playedAt.toIso8601String(),
    };
  }

  CompletedMatch? _fromMap(Map<String, dynamic> map) {
    final outcomeName = map['outcome'];
    final difficultyName = map['difficulty'];
    final playedAtRaw = map['playedAt'];

    if (outcomeName is! String) return null;
    if (difficultyName is! String) return null;
    if (playedAtRaw is! String) return null;

    final outcome = MatchOutcome.fromName(outcomeName);
    final difficulty = GameDifficulty.fromName(difficultyName);
    final playedAt = DateTime.tryParse(playedAtRaw);

    if (outcome == null) return null;
    if (difficulty == null) return null;
    if (playedAt == null) return null;

    return CompletedMatch(
      outcome: outcome,
      difficulty: difficulty,
      playedAt: playedAt,
    );
  }
}
