import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/chat/model/room_cursor_model.dart';

final roomCursorProvider =
    StateNotifierProvider.family<RoomCursorNotifier, List<RoomCursor>, String>(
      (ref, roomId) => RoomCursorNotifier(),
    );

class RoomCursorNotifier extends StateNotifier<List<RoomCursor>> {
  RoomCursorNotifier() : super([]);

  void setInitial(List<RoomCursor> cursors) {
    state = cursors;
  }

  void updateCursor({required int mbNo, String? lastReadId}) {
    final list = [...state];
    final idx = list.indexWhere((c) => c.mbNo == mbNo);
    final item = RoomCursor(mbNo: mbNo, lastReadId: lastReadId);

    if (idx == -1) {
      list.add(item);
    } else {
      list[idx] = item;
    }
    state = list;
  }
}
