import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';

/// ReportListConfig<T>
/// 공통 리스트 화면(ReportListScaffold)의 동작 정의.
/// 탭 구성, 데이터 로드, 검색 조건, 라우트, 아이템 렌더링 방식을 지정.

typedef TabPredicate<T> = bool Function(T item, int tabIndex); // 탭별 노출 여부
typedef SearchPredicate<T> =
    bool Function(T item, String selectedFilter, String q); // 검색/필터 조건
typedef MapToProps<T> =
    ReportListItemProps Function(T item); // T -> 기본 아이템 속성 변환
typedef EmptyMessageBuilder =
    String Function(int tabIndex, {required bool mineOnly}); // 빈 상태 문구
typedef MineOnlyPredicate<T> = bool Function(T item); // 내 글만 보기 조건
typedef ItemBuilder<T> =
    Widget Function(BuildContext context, T item); // 커스텀 아이템 렌더러

class ReportListConfig<T> {
  // UI 구성 정보
  final List<String> tabs; // 상단 탭 목록
  final List<String> filters; // 검색 필터 목록
  final EmptyMessageBuilder emptyMessage; // 데이터 없음 문구
  final bool showFab; // 등록 버튼 표시 여부
  final String? emptyIconPath; // 빈 상태 아이콘

  // 라우트/화면 이동
  final String detailRouteName; // 상세 화면 라우트명
  final String? myDetailRouteName; // 내 글 전용 상세 라우트(옵션)
  final String formRouteName; // 등록 화면 라우트명

  // 데이터 로드 및 매핑
  final Future<List<T>> Function() load; // 데이터 로드(API 또는 mock)
  final MapToProps<T>? mapToProps; // 모델 → 기본 아이템 속성 변환(기본 렌더 사용 시)

  // 필터링 및 검색 조건
  final TabPredicate<T> tabPredicate; // 탭별 표시 조건
  final SearchPredicate<T> searchPredicate; // 검색 조건
  final MineOnlyPredicate<T>? mineOnlyPredicate; // 내 글 조건

  // 동작
  final void Function(BuildContext context, T item)? onItemTap; // 항목 탭 동작

  // 아이템 렌더링
  // itemBuilder 제공 시: 완전 커스텀 렌더링
  // 없으면 mapToProps로 기본 아이템(BaseListItem 등) 렌더링
  final ItemBuilder<T>? itemBuilder;

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
    this.mapToProps,
    required this.tabPredicate,
    required this.searchPredicate,
    this.mineOnlyPredicate,
    this.onItemTap,
    this.itemBuilder,
  });
}
