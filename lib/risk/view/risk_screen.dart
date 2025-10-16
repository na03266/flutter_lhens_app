import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import 'package:lhens_app/risk/view/risk_detail_screen.dart';
import 'package:lhens_app/risk/view/risk_form_screen.dart';
import 'package:lhens_app/mock/risk/mock_risk_models.dart';
import 'package:lhens_app/mock/risk/mock_risk_data.dart';

class RiskScreen extends ConsumerWidget {
  static String get routeName => '위험신고';

  final bool mineOnly; // 내 위험신고 내역
  final bool showFab; // 작성(FAB) 버튼 노출

  const RiskScreen({super.key, this.mineOnly = false, this.showFab = true});

  static const String _currentUser = '조예빈(1001599)';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ReportListConfig<RiskItem>(
      tabs: const ['공개', '요청(비공개)'],
      filters: const ['전체', '작성자', '유형명'],

      // empty 문구
      emptyMessage: (tabIndex, {required bool mineOnly}) {
        if (mineOnly) {
          switch (tabIndex) {
            case 1:
              return '등록한 공개 위험신고가 없습니다.';
            case 2:
              return '등록한 비공개 위험신고가 없습니다.';
            default:
              return '등록한 위험신고가 없습니다.';
          }
        } else {
          switch (tabIndex) {
            case 1:
              return '등록된 공개 위험신고가 없습니다.';
            case 2:
              return '등록된 비공개 위험신고가 없습니다.';
            default:
              return '등록된 위험신고가 없습니다.';
          }
        }
      },
      // 내 위험신고 내역 / 위험신고 empty 아이콘
      emptyIconPath: mineOnly
          ? Assets.icons.features.reportDoc.path
          : Assets.icons.tabs.danger.path,

      // FAB 및 라우팅 이름
      showFab: showFab,
      formRouteName: RiskFormScreen.routeName,
      detailRouteName: RiskDetailScreen.routeName,
      myDetailRouteName: '내 위험신고 상세',

      // 데이터 로드 (mock 데이터)
      // load: () async => <RiskItem>[],
      load: () async => generateRiskItems(
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
      //   RiskDetailScreen.routeName,
      //   extra: item, // ← API 연동 후 실제 데이터 전달
      // ),
    );

    return ReportListScaffold<RiskItem>(config: config, mineOnly: mineOnly);
  }
}
