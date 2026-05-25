import 'package:equatable/equatable.dart';

import '../../domain/entities/game_difficulty.dart';
import '../../domain/entities/game_session.dart';

final class GameControllerState extends Equatable {
  const GameControllerState({
    required this.session,
    required this.difficulty,
    required this.isCpuThinking,
  });

  final GameSession session;
  final GameDifficulty difficulty;
  final bool isCpuThinking;

  GameControllerState copyWith({
    GameSession? session,
    GameDifficulty? difficulty,
    bool? isCpuThinking,
  }) {
    return GameControllerState(
      session: session ?? this.session,
      difficulty: difficulty ?? this.difficulty,
      isCpuThinking: isCpuThinking ?? this.isCpuThinking,
    );
  }

  @override
  List<Object?> get props => [session, difficulty, isCpuThinking];
}
