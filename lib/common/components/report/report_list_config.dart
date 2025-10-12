import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';

/// ReportListConfig<T>
/// 공통 리스트 화면(ReportListScaffold)의 동작 정의.
/// 각 기능별(위험신고, 민원제안 등) 탭 구성, 데이터 로드, 검색 조건, 라우트 정보 지정.

typedef TabPredicate<T> = bool Function(T item, int tabIndex);
typedef SearchPredicate<T> =
    bool Function(T item, String selectedFilter, String q);
typedef MapToProps<T> = ReportListItemProps Function(T item);
typedef EmptyMessageBuilder =
    String Function(int tabIndex, {required bool mineOnly});
typedef MineOnlyPredicate<T> = bool Function(T item);

class ReportListConfig<T> {
  // UI 구성 정보
  final List<String> tabs; // 상단 탭 목록
  final List<String> filters; // 검색 필터 목록
  final EmptyMessageBuilder emptyMessage; // 데이터 없음 문구
  final bool showFab; // 등록 버튼 표시 여부
  final String? emptyIconPath; // 빈 상태 아이콘

  // 라우트/화면 이동
  final String detailRouteName; // 상세 화면 라우트명
  final String? myDetailRouteName; // 내 글 전용 상세 라우트 (선택)
  final String formRouteName; // 등록 화면 라우트명

  // 데이터 로드 및 매핑
  final Future<List<T>> Function() load; // 데이터 로드 함수(API 또는 mock)
  final MapToProps<T>? mapToProps; // 모델 → UI 데이터 변환

  // 필터링 및 검색 조건
  final TabPredicate<T> tabPredicate; // 탭별 표시 조건
  final SearchPredicate<T> searchPredicate; // 검색 조건
  final MineOnlyPredicate<T>? mineOnlyPredicate; // 내 글 조건

  // 기타 동작
  final void Function(BuildContext context, T item)? onItemTap; // 항목 클릭 동작

  const ReportListConfig({
    required this.tabs,
    required this.filters,
    required this.emptyMessage,
    required this.showFab,
    this.emptyIconPath,
    required this.detailRouteName,
    this.myDetailRouteName,
    required this.formRouteName,
    required this.load,
    required this.tabPredicate,
    required this.searchPredicate,
    this.mapToProps,
    this.mineOnlyPredicate,
    this.onItemTap,
  });
}
