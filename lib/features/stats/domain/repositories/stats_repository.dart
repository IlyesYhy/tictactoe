import '../entities/completed_match.dart';
import '../entities/match_history.dart';

abstract interface class StatsRepository {
  Future<MatchHistory> getMatchHistory();

  Future<void> recordMatch(CompletedMatch match);
}
