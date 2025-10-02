import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/doc_list_item.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/drawer/salary/view/salary_auth_screen.dart';

class SalaryScreen extends ConsumerStatefulWidget {
  static String get routeName => '급여명세서';

  const SalaryScreen({super.key});

  @override
  ConsumerState<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends ConsumerState<SalaryScreen> {
  final List<String> years = ['2025', '2024', '2023'];
  String? year = '2025';

  bool _scrolled = false; // 스크롤 시 셀렉터 하단 그림자

  @override
  Widget build(BuildContext context) {
    final items = _itemsFor(year!);
    final noData = items.isEmpty;

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
              child: Selector<String>(
                items: years,
                selected: year,
                getLabel: (y) => '$y년',
                onSelected: (v) => setState(() => year = v),
              ),
            ),
            SizedBox(height: 12.h),

            // 리스트 영역
            Expanded(
              child: noData
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
                        itemCount: items.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (_, i) => items[i],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _itemsFor(String y) {
    final months = [9, 8, 7, 6, 5, 4, 3, 2, 1];
    return months
        .map(
          (m) => DocListItem(
            title: '$y년 $m월 급여명세서',
            onPreview: () => context.pushNamed(SalaryAuthScreen.routeName),
            onDownload: () => context.pushNamed(SalaryAuthScreen.routeName),
          ),
        )
        .toList();
  }
}
