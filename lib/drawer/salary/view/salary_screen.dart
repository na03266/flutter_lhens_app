import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/doc_list_item.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/drawer/salary/model/salary_model.dart';
import 'package:lhens_app/drawer/salary/provider/salary_provider.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/drawer/salary/view/salary_auth_screen.dart';

class SalaryScreen extends ConsumerStatefulWidget {
  static String get routeName => '급여명세서';

  const SalaryScreen({super.key});

  @override
  ConsumerState<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends ConsumerState<SalaryScreen> {
  int year = DateTime.now().year;
  bool _scrolled = false; // 스크롤 시 셀렉터 하단 그림자
  @override
  void initState() {
    super.initState();
    ref.read(salaryProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salaryProvider);

    if (state is SalaryModelLoading) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isSalaries = state is SalaryModel;
    final yearItems =
        SplayTreeSet<int>((a, b) => b.compareTo(a)) // 최신연도 우선
          ..add(year) // 현재 선택 연도(또는 현재연도) 보장
          ..addAll(isSalaries ? state.years : const []);

    final items = yearItems.toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 셀렉터 (고정) + 하단 그림자
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: _scrolled ? AppShadows.stickyBar : null,
              ),
              child: Selector<int>(
                items: isSalaries ? items : [year],
                selected: year,
                getLabel: (y) => '$y년',
                onSelected: (v) {
                  setState(() => year = v);
                  ref.read(salaryProvider.notifier).getSalaries(year: year);
                },
              ),
            ),
            SizedBox(height: 12.h),

            // 리스트 영역
            Expanded(
              child: state is! SalaryModel || state.data.isEmpty
                  ? EmptyState(
                      iconPath: Assets.icons.document.path,
                      message: '조회 가능한 급여명세서가 없습니다.',
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n is ScrollUpdateNotification) {
                          final atTop = n.metrics.pixels <= 0;
                          if (_scrolled == atTop) {
                            setState(() => _scrolled = !atTop);
                          }
                        }
                        return false;
                      },
                      child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        itemCount: state.data.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (_, i) {
                          final salary = state.data[i];
                          return DocListItem(
                            title: '${salary.year}년 ${salary.month}월 급여명세서',
                            onPreview: () => context.pushNamed(
                              SalaryAuthScreen.routeName,
                              pathParameters: {'id': salary.saId.toString()},
                            ),
                            onDownload: () => context.pushNamed(
                              SalaryAuthScreen.routeName,
                              pathParameters: {'id': salary.saId.toString()},
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
