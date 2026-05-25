import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/data/repositories/local_cpu_repository.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/services/cpu/cpu_strategy.dart';

void main() {
  group('LocalCpuRepository', () {
    test('delegates the move selection to the injected strategy', () async {
      const repository = LocalCpuRepository(_FakeStrategy(7));

      final move = await repository.chooseMove(Board.empty());

      expect(move, 7);
    });
  });
}

final class _FakeStrategy implements CpuStrategy {
  const _FakeStrategy(this._move);

  final int _move;

  @override
  int chooseMove(Board board) => _move;
}
