import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_form_screen.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/mock/complaint/mock_complaint_models.dart';
import 'package:lhens_app/mock/complaint/mock_complaint_data.dart';

class ComplaintScreen extends ConsumerWidget {
  static String get routeName => '민원제안접수';
  final bool mineOnly; // 내 민원제안 내역
  final bool showFab; // 작성(FAB) 버튼

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

      // empty 문구
      emptyMessage: (tab, {required bool mineOnly}) {
        if (mineOnly) {
          switch (tab) {
            case 1:
              return '등록한 공개 제안이 없습니다.';
            case 2:
              return '등록한 비공개 제안이 없습니다.';
            default:
              return '등록한 제안이 없습니다.';
          }
        } else {
          switch (tab) {
            case 1:
              return '등록된 공개 제안이 없습니다.';
            case 2:
              return '등록된 비공개 제안이 없습니다.';
            default:
              return '등록된 제안이 없습니다.';
          }
        }
      },
      emptyIconPath: Assets.icons.features.suggestionDoc.path,

      // FAB 및 라우팅 이름
      showFab: showFab,
      formRouteName: ComplaintFormScreen.routeName,
      detailRouteName: '민원제안 상세',
      myDetailRouteName: '내 민원제안 상세',

      // 데이터 로드 (mock 데이터)
      // load: () async => <ComplaintItem>[],
      load: () async => generateComplaintItems(
        40,
        secretRatio: 0.25,
        authorA: _currentUser,
        authorB: '홍길동(1002001)',
      ),

      // 탭 필터
      tabPredicate: (e, tab) {
        switch (tab) {
          case 1:
            return !e.secret; // 공개
          case 2:
            return e.secret; // 비공개
          default:
            return true; // 전체
        }
      },

      // 검색 필터
      searchPredicate: (e, selected, q) {
        if (q.isEmpty) return true;
        final title = e.title.toLowerCase();
        final author = e.author.toLowerCase();
        final type = e.typeName.toLowerCase();

        switch (selected) {
          case '작성자':
            return author.contains(q);
          case '유형명':
            return type.contains(q);
          default:
            return title.contains(q) || author.contains(q) || type.contains(q);
        }
      },

      // 리스트 아이템 표시용 DTO 매핑
      mapToProps: (e) => ReportListItemProps(
        status: e.status,
        typeName: e.typeName,
        title: e.title,
        author: e.author,
        dateText: e.dateText,
        commentCount: e.comments,
        secret: e.secret,
      ),

      // 내 글 필터 조건
      mineOnlyPredicate: (e) => e.author == _currentUser,

      // 상세 화면으로 데이터 전달이 필요한 경우에 사용
      // 지정하면 기본 pushNamed 대신 이 콜백이 실행
      //
      // onItemTap: (ctx, item) => ctx.pushNamed(
      //   '민원제안 상세',
      //   extra: item, // ← API 연동 후 실제 데이터 전달
      // ),
    );

    return ReportListScaffold<ComplaintItem>(
      config: config,
      mineOnly: mineOnly,
    );
  }
}
