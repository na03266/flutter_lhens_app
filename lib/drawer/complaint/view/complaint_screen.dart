// lib/features/complaint/view/complaint_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_form_screen.dart';
import 'package:lhens_app/mock/complaint/mock_complaint_models.dart';
import 'package:lhens_app/mock/complaint/mock_complaint_data.dart';

class ComplaintScreen extends ConsumerWidget {
  static String get routeName => '민원제안접수';

  final bool mineOnly; // 내 글만 보기
  final bool showFab; // 작성 버튼 노출
  const ComplaintScreen({
    super.key,
    this.mineOnly = false,
    this.showFab = true,
  });

  static const String _currentUser = '조예빈(1001599)';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ReportListConfig<ComplaintItem>(
      tabs: const ['공개', '요청(비공개)'],
      filters: const ['전체', '작성자', '유형명'],

      emptyMessage: (tab, {required bool mineOnly}) => switch (tab) {
        1 => mineOnly ? '등록한 공개 제안이 없습니다.' : '등록된 공개 제안이 없습니다.',
        2 => mineOnly ? '등록한 비공개 제안이 없습니다.' : '등록된 비공개 제안이 없습니다.',
        _ => mineOnly ? '등록한 제안이 없습니다.' : '등록된 제안이 없습니다.',
      },

      showFab: showFab,
      detailRouteName: '민원제안 상세',
      // GoRouter에 등록 예정
      myDetailRouteName: '내 민원제안 상세',
      // 필요 없으면 null
      formRouteName: ComplaintFormScreen.routeName, // '민원제안 등록'

      // GoRouter에 등록 예정
      load: () async => generateComplaintItems(
        40,
        secretRatio: 0.25,
        authorA: _currentUser,
        authorB: '홍길동(1002001)',
      ),

      tabPredicate: (e, tab) => switch (tab) {
        1 => !e.secret, // 공개
        2 => e.secret, // 비공개
        _ => true,
      },

      searchPredicate: (e, f, q) {
        if (q.isEmpty) return true;
        final title = e.title.toLowerCase();
        final author = e.author.toLowerCase();
        final type = e.typeName.toLowerCase();
        return switch (f) {
          '작성자' => author.contains(q),
          '유형명' => type.contains(q),
          _ => title.contains(q) || author.contains(q) || type.contains(q),
        };
      },

      mapToProps: (e) => ReportListItemProps(
        status: e.status,
        // ItemStatus?
        typeName: e.typeName,
        title: e.title,
        author: e.author,
        dateText: e.dateText,
        commentCount: e.comments,
        secret: e.secret,
      ),

      mineOnlyPredicate: (e) => e.author == _currentUser,
      // onItemTap: (ctx, item) => ctx.pushNamed('민원제안 상세', extra: item),
    );

    return ReportListScaffold<ComplaintItem>(
      config: config,
      mineOnly: mineOnly,
    );
  }
}
