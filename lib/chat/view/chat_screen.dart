import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/chat/provider/chat_room_provider.dart';
import 'package:lhens_app/chat/repository/chat_socket.dart';

import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/buttons/fab_add_button.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/model/cursor_pagination_model.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/chat/component/chat_list_item.dart';
import 'package:lhens_app/chat/view/chat_detail_screen.dart';
import 'package:lhens_app/user/model/user_picker_args.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static String get routeName => '커뮤니케이션';

  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<String> _categories = const ['전체'];
  String _category = '전체';

  // Mock 데이터 (추후 provider로 대체)
  // final List<({String name, int participants, int unread})> _items = [];
  final List<({String name, int participants, int unread})> _items = [
    (name: 'LH E&S 기획팀', participants: 5, unread: 2),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
  ];

  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(chatGatewayClientProvider);
      ref.read(chatRoomProvider.notifier).paginate(fetchOrder: ['roomId_DESC']);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final asyncItems = ref.watch(chatItemsProvider); // 추후 전환
    final state = ref.watch(chatRoomProvider);
    print(state is CursorPagination ? state.data :'');
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 고정 검색바 + 스티키 그림자
            Container(
              decoration: BoxDecoration(
                color: AppColors.bg,
                boxShadow: _scrolled ? AppShadows.stickyBar : null,
              ),
              child: FilterSearchBar<String>(
                items: _categories,
                selected: _category,
                getLabel: (v) => v,
                onSelected: (v) => setState(() => _category = v),
                controller: TextEditingController(),
                // 검색 미사용
                onSubmitted: (_) {},
              ),
            ),
            SizedBox(height: 14.h),

            // 스크롤 영역
            Expanded(
              child: state is CursorPagination && state.data.isNotEmpty
                  ? NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n is ScrollUpdateNotification) {
                          final atTop = n.metrics.pixels <= 0;
                          if (_scrolled == atTop) {
                            setState(() => _scrolled = !atTop);
                          }
                        }
                        return false;
                      },
                      child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: state.data.length + 1,
                        // 헤더 + 아이템
                        separatorBuilder: (_, i) => i == 0
                            ? const SizedBox.shrink()
                            : SizedBox(height: 10.h),
                        itemBuilder: (_, i) {
                          if (i == 0) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 8.h),
                              child: CountInline(
                                label: '전체',
                                count: state.data.length,
                                showSuffix: false,
                              ),
                            );
                          }
                          final e = state.data[i - 1];
                          return ChatListItem(
                            title: e.name,
                            participants: e.participants,
                            unreadCount: e.unread,
                            onTap: () => GoRouter.of(
                              context,
                            ).pushNamed(ChatDetailScreen.routeName),
                          );
                        },
                      ),
                    )
                  : EmptyState(
                      iconPath: Assets.icons.tabs.chat.path,
                      message: '참여 중인 채팅방이 없습니다.',
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: FabAddButton(
          label: '새 채팅',
          onTap: () async {
            // 1) 채팅방 이름 설정 화면으로 이동
            final roomName = await GoRouter.of(
              context,
            ).pushNamed<String>('채팅방 정보');

            if (!context.mounted ||
                roomName == null ||
                roomName.trim().isEmpty) {
              return;
            }

            // 2) 사용자 선택 화면으로 이동
            final res = await GoRouter.of(context).pushNamed<UserPickResult>(
              '커뮤니케이션-사용자선택',
              extra: UserPickerArgs(UserPickerMode.chatCreate),
            );

            if (!context.mounted || res == null) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('채팅방 "$roomName"을 생성했습니다.'),
                duration: const Duration(seconds: 1),
              ),
            );

            GoRouter.of(context).pushNamed(ChatDetailScreen.routeName);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
