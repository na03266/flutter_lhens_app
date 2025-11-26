import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/base_list_item.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/drawer/provider/board_provider.dart';
import 'package:lhens_app/risk/provider/risk_provider.dart';
import 'package:lhens_app/risk/view/risk_detail_screen.dart';

class RiskScreen extends ConsumerStatefulWidget {
  static String get routeName => '위험신고';

  final bool mineOnly; // 내 위험신고 내역
  final bool showFab; // 작성(FAB) 버튼 노출

  const RiskScreen({super.key, this.mineOnly = false, this.showFab = true});


  @override
  ConsumerState<RiskScreen> createState() => _RiskScreenState();
}

class _RiskScreenState extends ConsumerState<RiskScreen> {
  String caName = '';
  String wr1 = '';
  String wr2 = '';
  String title = '';

  @override
  Widget build(BuildContext context) {

    final board = ref.watch(boardProvider);
    if (board is! BoardInfo) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final item = board.items.firstWhere(
          (element) => element.boTable == 'comm22',
    );
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffoldV2<PostModel>(
        tabs: item.boCategoryList.split('|'),
        filters: [
          '전체',
          ...item.bo1.split('|').length > 1 ? item.bo1.split('|') : [],
        ],
        selectTabName: (String selectedTab) {
          setState(() {
            caName = selectedTab.replaceAll(" ", "");
          });
          ref
              .read(riskProvider.notifier)
              .paginate(fetchPage: 1, caName: selectedTab, forceRefetch: true);
        },
        selectFilterName: (String selectedFilter) {
          setState(() {
            if (selectedFilter == '전체') {
              wr1 = '';
            } else {
              wr1 = selectedFilter;
            }
          });
        },
        onSearched: (String input) {
          setState(() {
            title = input;
          });
          ref
              .read(riskProvider.notifier)
              .paginate(fetchPage: 1, caName: caName, wr1: wr1, title: title);
        },

        provider: riskProvider,
        changePage: (int page) {
          ref
              .read(riskProvider.notifier)
              .paginate(
            fetchPage: page,
            caName: caName,
            wr1: wr1,
            title: title,
          );
        },
        itemBuilder: (_, index, model) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                RiskDetailScreen.routeName,
                pathParameters: {'rid': model.wrId.toString()},
              );
            },
            child: BaseListItem.fromPostModelForComplaint(model: model),
          );
        },
      ),
    );

    // final config = ReportListConfig<RiskItem>(
    //   tabs: const ['공개', '요청(비공개)'],
    //   filters: const ['전체', '작성자', '유형명'],
    //
    //   // empty 문구
    //   emptyMessage: (tabIndex, {required bool mineOnly}) {
    //     if (mineOnly) {
    //       switch (tabIndex) {
    //         case 1:
    //           return '등록한 공개 위험신고가 없습니다.';
    //         case 2:
    //           return '등록한 비공개 위험신고가 없습니다.';
    //         default:
    //           return '등록한 위험신고가 없습니다.';
    //       }
    //     } else {
    //       switch (tabIndex) {
    //         case 1:
    //           return '등록된 공개 위험신고가 없습니다.';
    //         case 2:
    //           return '등록된 비공개 위험신고가 없습니다.';
    //         default:
    //           return '등록된 위험신고가 없습니다.';
    //       }
    //     }
    //   },
    //   // 내 위험신고 내역 / 위험신고 empty 아이콘
    //   emptyIconPath: widget.mineOnly
    //       ? Assets.icons.features.reportDoc.path
    //       : Assets.icons.tabs.danger.path,
    //
    //   // FAB 및 라우팅 이름
    //   showFab: widget.showFab,
    //   formRouteName: RiskFormScreen.routeName,
    //   detailRouteName: RiskDetailScreen.routeName,
    //   myDetailRouteName: '내 위험신고 상세',
    //
    //   // 데이터 로드 (mock 데이터)
    //   // load: () async => <RiskItem>[],
    //   load: () async => generateRiskItems(
    //     40,
    //     secretRatio: 0.25,
    //     authorA: RiskScreen._currentUser,
    //     authorB: '홍길동(1002001)',
    //   ),
    //
    //   // 탭 필터
    //   tabPredicate: (e, tab) {
    //     switch (tab) {
    //       case 1:
    //         return !e.secret; // 공개
    //       case 2:
    //         return e.secret; // 비공개
    //       default:
    //         return true; // 전체
    //     }
    //   },
    //
    //   // 검색 필터
    //   searchPredicate: (e, selected, q) {
    //     if (q.isEmpty) return true;
    //     final title = e.title.toLowerCase();
    //     final author = e.author.toLowerCase();
    //     final type = e.typeName.toLowerCase();
    //     switch (selected) {
    //       case '작성자':
    //         return author.contains(q);
    //       case '유형명':
    //         return type.contains(q);
    //       default:
    //         return title.contains(q) || author.contains(q) || type.contains(q);
    //     }
    //   },
    //
    //   // 리스트 아이템 표시용 DTO 매핑
    //   mapToProps: (e) => ReportListItemProps(
    //     status: e.status,
    //     typeName: e.typeName,
    //     title: e.title,
    //     author: e.author,
    //     dateText: e.dateText,
    //     commentCount: e.comments,
    //     secret: e.secret,
    //   ),
    //
    //   // 내 글 필터 조건
    //   mineOnlyPredicate: (e) => e.author == RiskScreen._currentUser,
    //
    //   // 상세 화면으로 데이터 전달이 필요한 경우에 사용
    //   // 지정하면 기본 pushNamed 대신 이 콜백이 실행
    //   //
    //   // onItemTap: (ctx, item) => ctx.pushNamed(
    //   //   RiskDetailScreen.routeName,
    //   //   extra: item, // ← API 연동 후 실제 데이터 전달
    //   // ),
    // );
    //
    // return ReportListScaffold<RiskItem>(config: config, mineOnly: widget.mineOnly);
  }
}
