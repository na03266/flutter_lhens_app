import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/buttons/fab_add_button.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/chat/component/communication_list_item.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/chat/view/chat_detail_screen.dart';
import 'package:lhens_app/user/view/user_picker_screen.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class ChatScreen extends StatefulWidget {
  static String get routeName => '커뮤니케이션';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // 단일 카테고리 필터 (예시)
  final List<String> _categories = const ['전체'];
  String _category = '전체';

  // Mock 데이터: 그룹명, 참여자 수, 안읽은 개수
  final List<({String name, int participants, int unread})> _items = [
    (name: 'LH E&S 기획팀', participants: 5, unread: 2),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
    (name: 'LH E&S 기획팀', participants: 5, unread: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final hasData = _items.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상단: 카테고리 드롭다운 (FilterSearchBar 재사용)
            FilterSearchBar<String>(
              items: _categories,
              selected: _category,
              getLabel: (v) => v,
              onSelected: (v) => setState(() => _category = v),
              controller: TextEditingController(), // 검색 미사용
              onSubmitted: (_) {},
            ),
            SizedBox(height: 12.h),

            // 건수 표시
            CountInline(label: '전체', count: _items.length),
            SizedBox(height: 12.h),

            // 리스트 영역
            Expanded(
              child: hasData
                  ? ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (_, i) {
                        final e = _items[i];
                        return CommunicationListItem(
                          title: e.name,
                          participants: e.participants,
                          unreadCount: e.unread,
                          onTap: () => GoRouter.of(context).pushNamed(ChatDetailScreen.routeName),
                        );
                      },
                    )
                  : EmptyState(
                      iconPath: Assets.icons.document.path,
                      message: '등록된 커뮤니케이션이 없습니다.',
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
            final res = await GoRouter.of(context)
                .pushNamed<UserPickResult>(UserPickerScreen.routeName);
            if (res != null && res.members.isNotEmpty) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${res.members.length}명으로 채팅방을 생성했습니다.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
                GoRouter.of(context).pushNamed(ChatDetailScreen.routeName);
              }
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
