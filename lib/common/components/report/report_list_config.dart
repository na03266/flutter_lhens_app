import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';

typedef TabPredicate<T> = bool Function(T item, int tabIndex);
typedef SearchPredicate<T> = bool Function(
    T item, String selectedFilter, String q);
typedef MapToProps<T> = ReportListItemProps Function(T item);
typedef EmptyMessageBuilder = String Function(int tabIndex,
    {required bool mineOnly});
typedef MineOnlyPredicate<T> = bool Function(T item);

class ReportListConfig<T> {
  final List<String> tabs;            // 탭 이름
  final List<String> filters;         // 검색 필터
  final EmptyMessageBuilder emptyMessage;

  final bool showFab;

  final String detailRouteName;
  final String? myDetailRouteName;    // mineOnly 전용 상세 라우트
  final String formRouteName;

  final Future<List<T>> Function() load;

  final TabPredicate<T> tabPredicate;
  final SearchPredicate<T> searchPredicate;
  final MapToProps<T> mapToProps;
  final MineOnlyPredicate<T>? mineOnlyPredicate;

  // 상세 진입 시 아이템 전달할 때 사용 (선택)
  final void Function(BuildContext context, T item)? onItemTap;

  const ReportListConfig({
    required this.tabs,
    required this.filters,
    required this.emptyMessage,
    required this.showFab,
    required this.detailRouteName,
    this.myDetailRouteName,
    required this.formRouteName,
    required this.load,
    required this.tabPredicate,
    required this.searchPredicate,
    required this.mapToProps,
    this.mineOnlyPredicate,
    this.onItemTap,
  });
}