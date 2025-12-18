import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/alarm/component/alarm_item_list.dart';
import 'package:lhens_app/alarm/model/alarm_model.dart';
import 'package:lhens_app/alarm/provider/alarm_provider.dart';
import 'package:lhens_app/common/components/app_segmented_tabs.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_detail_screen.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_screen.dart';
import 'package:lhens_app/drawer/edu_event/view/edu_event_detail_screen.dart';
import 'package:lhens_app/drawer/edu_event/view/edu_event_screen.dart';
import 'package:lhens_app/drawer/notice/view/notice_detail_screen.dart';
import 'package:lhens_app/drawer/notice/view/notice_screen.dart';
import 'package:lhens_app/drawer/salary/view/salary_screen.dart';
import 'package:lhens_app/drawer/survey/view/survey_screen.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/manual/view/manual_detail_screen.dart';
import 'package:lhens_app/manual/view/manual_screen.dart';
import 'package:lhens_app/risk/view/risk_detail_screen.dart';
import 'package:lhens_app/risk/view/risk_screen.dart';

class AlarmScreen extends ConsumerStatefulWidget {
  static String get routeName => '알림';

  const AlarmScreen({super.key});

  @override
  ConsumerState<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends ConsumerState<AlarmScreen> {
  int _tabIndex = 0;

  String get _emptyMessage => switch (_tabIndex) {
    1 => '미확인 알림이 없습니다.',
    2 => '확인한 알림이 없습니다.',
    _ => '알림이 없습니다.',
  };

  void _handleTap(AlarmItemModel e) {
    ref.read(alarmProvider.notifier).makeAsRead(id: e.id);
    switch (e.title) {
      case '공지사항':
      case '외부공지사항':
      case '내부공지사항':
        if (e.data != null && e.data!.wrId != null) {
          GoRouter.of(context).pushNamed(
            NoticeDetailScreen.routeName,
            pathParameters: {'rid': e.data!.wrId!},
          );
        } else {
          GoRouter.of(context).pushNamed(NoticeScreen.routeName);
        }
        break;
      case '위험신고':
      case '위험요소건의':
      case '작업중지요청':
        if (e.data != null && e.data!.wrId != null) {
          GoRouter.of(context).pushNamed(
            RiskDetailScreen.routeName,
            pathParameters: {'rid': e.data!.wrId!},
          );
        } else {
          GoRouter.of(context).pushNamed(RiskScreen.routeName);
        }
        break;
      case '민원제안접수':
        if (e.data != null && e.data!.wrId != null) {
          GoRouter.of(context).pushNamed(
            ComplaintDetailScreen.routeName,
            pathParameters: {'rid': e.data!.wrId!},
          );
        } else {
          GoRouter.of(context).pushNamed(ComplaintScreen.routeName);
        }
        break;
      case '교육행사정보':
      case '교육':
      case '행사':
        if (e.data != null && e.data!.wrId != null) {
          GoRouter.of(context).pushNamed(
            EduEventDetailScreen.routeName,
            pathParameters: {'rid': e.data!.wrId!},
          );
        } else {
          GoRouter.of(context).pushNamed(EduEventScreen.routeName);
        }
        break;
      case '급여명세서':
        GoRouter.of(context).pushNamed(SalaryScreen.routeName);
        break;
      case '업무메뉴얼':
        if (e.data != null && e.data!.wrId != null) {
          GoRouter.of(context).pushNamed(
            ManualDetailScreen.routeName,
            pathParameters: {'rid': e.data!.wrId!},
          );
        } else {
          GoRouter.of(context).pushNamed(ManualScreen.routeName);
        }
        break;
      case '설문조사':
        GoRouter.of(context).pushNamed(SurveyScreen.routeName);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(alarmProvider);
    // 로딩
    if (state is AlarmModelLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러
    if (state is AlarmModelError) {
      return Center(child: Text(state.message));
    }
    if (state is! AlarmModel) {
      // 방어 로직
      return const SizedBox.shrink();
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(alarmProvider.notifier).getItems();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSegmentedTabs(
              index: _tabIndex,
              onChanged: (i) async {
                setState(() => _tabIndex = i);
                if (i == 1) {
                  await ref.read(alarmProvider.notifier).getItems(isRead: 0);
                } else if (i == 2) {
                  await ref.read(alarmProvider.notifier).getItems(isRead: 1);
                } else {
                  await ref.read(alarmProvider.notifier).getItems();
                }
              },
              rightTabs: const ['미확인', '확인'],
              badgeCount: state.count,
            ),
            SizedBox(height: 16.h),

            Expanded(
              child: state.data.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 40.h),
                      children: [
                        SizedBox(height: 240.h),
                        EmptyState(
                          iconPath: Assets.icons.bell.path,
                          message: _emptyMessage,
                        ),
                        SizedBox(height: 240.h),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 40.h),
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemCount: state.count,
                      itemBuilder: (context, i) {
                        final e = state.data[i];
                        return AlarmListItem(
                          category: e.title,
                          title: e.body,
                          date: e.sentAt,
                          read: e.isRead,
                          onTap: () => _handleTap(e),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
