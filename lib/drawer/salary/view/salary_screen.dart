import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/doc_list_item.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/drawer/salary/view/salary_auth_screen.dart';

class SalaryScreen extends StatefulWidget {
  static String get routeName => '급여명세서';

  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  String? year = '2025';
  final List<String> years = ['2025', '2024', '2023'];

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
            Selector<String>(
              label: '연도 선택',
              items: years,
              selected: year,
              getLabel: (y) => '$y년',
              onSelected: (v) => setState(() => year = v),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: noData
                  ? EmptyState(
                      iconPath: Assets.icons.document.path,
                      message: '조회 가능한 급여명세서가 없습니다.',
                    )
                  : ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (_, i) => items[i],
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
