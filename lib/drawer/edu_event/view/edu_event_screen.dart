import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/edu_event/component/edu_event_list_item.dart';
import 'package:lhens_app/drawer/edu_event/view/edu_event_detail_screen.dart';

class EduEventScreen extends ConsumerWidget {
  static String get routeName => '교육행사정보';

  const EduEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ReportListConfig<_EduEventItem>(
      tabs: const ['교육', '행사'],
      filters: const ['전체'],
      emptyMessage: (tab, {required bool mineOnly}) => switch (tab) {
        1 => '등록된 교육 정보가 없습니다.',
        2 => '등록된 행사 정보가 없습니다.',
        _ => '등록된 항목이 없습니다.',
      },
      showFab: false,
      detailRouteName: EduEventDetailScreen.routeName,
      myDetailRouteName: null,
      formRouteName: '',
      load: () async => _mockEduEvents(),
      tabPredicate: (e, tab) => switch (tab) {
        1 => e.type == '교육정보',
        2 => e.type == '행사정보',
        _ => true,
      },
      searchPredicate: (e, f, q) {
        if (q.isEmpty) return true;
        final qq = q.toLowerCase();
        return e.title.toLowerCase().contains(qq) ||
            e.dept.toLowerCase().contains(qq) ||
            e.type.toLowerCase().contains(qq);
      },
      itemBuilder: (ctx, e) => EduEventListItem(
        typeName: e.type,
        title: e.title,
        targetDept: e.dept,
        periodText: e.period,
        onTap: () => ctx.pushNamed(EduEventDetailScreen.routeName),
      ),
      mineOnlyPredicate: null,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffold<_EduEventItem>(config: config),
    );
  }

  List<_EduEventItem> _mockEduEvents() => const [
    _EduEventItem(
      type: '교육정보',
      title: '2025 안전보건 규정 변경 및 실무교육',
      dept: '기획조정실 안전보건팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    _EduEventItem(
      type: '교육정보',
      title: '2025 신규 사업 기획 전략과 프로젝트 관리 프로세스 개선을 위한 실무 워크숍',
      dept: '기획조정실 사업기획팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    _EduEventItem(
      type: '행사정보',
      title: '2025 LH E&S 전사 체육대회 및 친목 행사',
      dept: '경영지원실 인사노무팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    _EduEventItem(
      type: '교육정보',
      title: '공공현장 안전·환경 관리 역량 강화를 위한 사례 기반 워크숍 및 실습 과정',
      dept: '사업운영본부 경기북부지사',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    _EduEventItem(
      type: '교육정보',
      title: '재무 보고서 작성 및 회계 처리 실습 과정',
      dept: '경영지원실 재무회계팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
  ];
}

class _EduEventItem {
  final String type;
  final String title;
  final String dept;
  final String period;

  const _EduEventItem({
    required this.type,
    required this.title,
    required this.dept,
    required this.period,
  });
}
