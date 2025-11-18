import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/board_info_model.dart';
import '../repository/board_repository.dart';

final boardProvider = StateNotifierProvider<BoardStateNotifier, BoardInfoBase>((
  ref,
) {
  final repository = ref.watch(boardRepositoryProvider);
  final notifier = BoardStateNotifier(repository: repository);

  return notifier;
});

class BoardStateNotifier extends StateNotifier<BoardInfoBase> {
  final BoardRepository repository;

  BoardStateNotifier({required this.repository}) : super(BoardInfoLoading()) {
    getList();
  }

  getList() async {
    final resp = await repository.getBoard();
    state = resp;
  }
}
