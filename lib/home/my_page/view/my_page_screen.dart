import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/home/my_page/component/my_nav_card.dart';
import 'package:lhens_app/home/my_page/change_info/view/change_info_screen.dart';

class MyPageScreen extends StatelessWidget {
  static String get routeName => '마이페이지';

  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              decoration: ShapeDecoration(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('홍길동', style: AppTextStyles.psb20),
                  SizedBox(height: 24.h),
                  ..._buildInfoList(const [
                    ['소속', '사업운영본부 경인지사'],
                    ['직급', '차장'],
                    ['사번', '1001103'],
                    ['입사일', '2018.01.15'],
                  ]),
                  _divider(),
                  ..._buildInfoList(const [
                    ['사무전화', '055-000-0000'],
                    ['휴대전화', '010-0000-0000'],
                    ['이메일', 'lh@test.com'],
                  ]),
                  _divider(),
                  _buildNavRow([
                    (
                      Assets.icons.features.surveyDoc.svg(),
                      '내 설문조사\n내역',
                      () => context.pushNamed('내 설문조사 내역'),
                    ),
                    (
                      Assets.icons.features.suggestionDoc.svg(),
                      '내 민원제안\n내역',
                      () => context.pushNamed('내 민원제안 내역'),
                    ),
                    (
                      Assets.icons.features.reportDoc.svg(),
                      '내 위험신고\n내역',
                      () => context.pushNamed('내 위험신고 내역'),
                    ),
                  ]),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: '정보변경',
              type: AppButtonType.outlined,
              onTap: () => context.pushNamed(ChangeInfoScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _buildInfoList(List<List<String>> items) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final e = items[i];
      children.add(LabelValueLine.single(label1: e[0], value1: e[1]));
      if (i != items.length - 1) children.add(SizedBox(height: 8.h));
    }
    return children;
  }

  static Widget _divider() => Column(
    children: [
      SizedBox(height: 16.h),
      const Divider(color: AppColors.border),
      SizedBox(height: 16.h),
    ],
  );

  static Widget _buildNavRow(List<(Widget, String, VoidCallback)> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map((it) => MyNavCard(icon: it.$1, title: it.$2, onTap: it.$3))
          .toList(),
    );
  }
}
