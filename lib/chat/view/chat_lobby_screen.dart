import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/chat/component/chat_list_item.dart';
import 'package:lhens_app/chat/model/chat_room_model.dart';
import 'package:lhens_app/chat/dto/create_chat_room_dto.dart';
import 'package:lhens_app/chat/provider/chat_room_provider.dart';
import 'package:lhens_app/chat/repository/chat_socket.dart';
import 'package:lhens_app/chat/view/chat_room_screen.dart';
import 'package:lhens_app/common/components/buttons/fab_add_button.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/model/cursor_pagination_model.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';
import 'package:lhens_app/user/model/user_picker_args.dart';

import 'chat_name_screen.dart';

class ChatLobbyScreen extends ConsumerStatefulWidget {
  static String get routeName => '커뮤니케이션';

  const ChatLobbyScreen({super.key});

  @override
  ConsumerState<ChatLobbyScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatLobbyScreen> {
  final List<String> _categories = const ['전체'];
  String _category = '전체';
  final ScrollController controller = ScrollController();

  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(chatGatewayClientProvider);
    });
  }

  void listener() {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(chatRoomProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatRoomProvider);
    // 1) 첫 로딩
    if (state is CursorPaginationLoading) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2) 에러
    if (state is CursorPaginationError) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: Text(state.message)),
      );
    }

    // 3) 데이터 상태 (일반 + fetchMore 중)
    if (state is! CursorPagination<ChatRoom>) {
      // 방어 로직
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: SizedBox.shrink(),
      );
    }
    // fetchMore 중인지 여부
    final isFetchingMore = state is CursorPaginationFetchingMore<ChatRoom>;
    final rooms = state.data;
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
              child: rooms.isNotEmpty
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
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref
                              .read(chatRoomProvider.notifier)
                              .paginate(
                                fetchOrder: ['roomId_DESC'],
                                forceRefetch: true,
                              );
                        },
                        child: ListView.separated(
                          controller: controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          // 헤더(1) + 방 목록 + (로딩 한 줄)
                          itemCount:
                              rooms.length + 1 + (isFetchingMore ? 1 : 0),
                          separatorBuilder: (_, i) {
                            // 헤더 위에는 간격 없음
                            if (i == 0) return const SizedBox.shrink();
                            return SizedBox(height: 10.h);
                          },
                          itemBuilder: (_, i) {
                            // 0: 헤더
                            if (i == 0) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 8.h),
                                child: CountInline(
                                  label: '전체',
                                  count: rooms.length,
                                  showSuffix: false,
                                ),
                              );
                            }

                            // 맨 마지막 아이템이 로딩 줄인지 체크
                            final isLoaderIndex =
                                isFetchingMore &&
                                i == rooms.length + 1; // 헤더 + rooms 뒤

                            if (isLoaderIndex) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // 그 외는 실제 채팅방 아이템
                            final room = rooms[i - 1]; // 헤더 한 칸 보정

                            return ChatListItem(
                              title: room.name,
                              participants: room.memberCount,
                              unreadCount: room.newMessageCount,
                              onTap: () => GoRouter.of(context).pushNamed(
                                ChatRoomScreen.routeName,
                                pathParameters: {'rid': room.roomId.toString()},
                              ),
                            );
                          },
                        ),
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
            ).pushNamed<String>(ChatNameScreen.routeName);

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

            ref
                .read(chatRoomProvider.notifier)
                .createChatRoom(
                  dto: CreateChatRoomDto(
                    name: roomName,
                    teamNos: res.departments,
                    memberNos: res.members,
                  ),
                );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('채팅방 "$roomName"을 생성했습니다.'),
                duration: const Duration(seconds: 1),
              ),
            );

            GoRouter.of(context).pushNamed(ChatRoomScreen.routeName);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
