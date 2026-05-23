import '../entities/board.dart';

/// Provides CPU move selection independently from the underlying
/// execution mechanism.
///
/// Implementations may use a local algorithm, an isolate,
/// a remote service or any other strategy.
abstract interface class AiRepository {
  /// Returns the index of the CPU move to play on [board].
  Future<int> chooseMove(Board board);
}
