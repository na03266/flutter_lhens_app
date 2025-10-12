import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/alarm/component/alarm_item_list.dart';
import 'package:lhens_app/common/components/app_segmented_tabs.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_screen.dart';
import 'package:lhens_app/drawer/notice/view/notice_screen.dart';
import 'package:lhens_app/drawer/survey/view/survey_screen.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/risk/view/risk_screen.dart';

class AlarmScreen extends StatefulWidget {
  static String get routeName => '알림';

  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  int _tabIndex = 0;

  // 임의 데이터
  static const List<_AlarmItem> _seed = [
    _AlarmItem(
      category: '설문조사',
      title: '제목입니다.',
      date: '2025. 05. 29',
      read: false,
    ),
    _AlarmItem(
      category: '공지사항',
      title: '제목입니다.',
      date: '2025. 05. 28',
      read: false,
    ),
    _AlarmItem(
      category: '민원제안접수',
      title: '제목입니다.',
      date: '2025. 05. 27',
      read: false,
    ),
    _AlarmItem(
      category: '위험신고',
      title: '제목입니다.',
      date: '2025. 05. 26',
      read: false,
    ),
    _AlarmItem(
      category: '설문조사',
      title: '제목입니다.',
      date: '2025. 05. 22',
      read: true,
    ),
    _AlarmItem(
      category: '공지사항',
      title: '제목입니다.',
      date: '2025. 05. 20',
      read: true,
    ),
  ];

  // 미확인 알림 우선
  List<_AlarmItem> get _orderedAll {
    final list = List<_AlarmItem>.from(_seed);
    list.sort((a, b) {
      if (a.read == b.read) return 0;
      return a.read ? 1 : -1;
    });
    return list;
  }

  List<_AlarmItem> get _filtered {
    final base = _orderedAll;
    return switch (_tabIndex) {
      1 => base.where((e) => !e.read).toList(),
      2 => base.where((e) => e.read).toList(),
      _ => base,
    };
  }

  String get _emptyMessage => switch (_tabIndex) {
    1 => '미확인 알림이 없습니다.',
    2 => '확인한 알림이 없습니다.',
    _ => '알림이 없습니다.',
  };

  void _handleTap(_AlarmItem e) {
    if (e.read) return;
    switch (e.category) {
      case '설문조사':
        GoRouter.of(context).pushNamed(SurveyScreen.routeName);
        break;
      case '공지사항':
        GoRouter.of(context).pushNamed(NoticeScreen.routeName);
        break;
      case '민원제안접수':
        GoRouter.of(context).pushNamed(ComplaintScreen.routeName);
        break;
      case '위험신고':
        GoRouter.of(context).pushNamed(RiskScreen.routeName);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final unreadCount = _seed.where((e) => !e.read).length;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSegmentedTabs(
            index: _tabIndex,
            onChanged: (i) => setState(() => _tabIndex = i),
            rightTabs: const ['미확인', '확인'],
            badgeCount: unreadCount,
          ),
          SizedBox(height: 16.h),

          Expanded(
            child: items.isEmpty
                ? _emptyTop(Assets.icons.bell.path, _emptyMessage)
                : ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 40.h),
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final e = items[i];
                      return AlarmListItem(
                        category: e.category,
                        title: e.title,
                        date: e.date,
                        read: e.read,
                        onTap: () => _handleTap(e),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyTop(String iconPath, String message) {
    return Column(
      children: [
        const Spacer(flex: 2),
        EmptyState(iconPath: iconPath, message: message),
        const Spacer(flex: 3),
      ],
    );
  }
}

class _AlarmItem {
  final String category;
  final String title;
  final String date;
  final bool read;

  const _AlarmItem({
    required this.category,
    required this.title,
    required this.date,
    required this.read,
  });
}
