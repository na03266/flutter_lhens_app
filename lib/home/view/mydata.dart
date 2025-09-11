import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import '../../common/const/appBorderRadius.dart';
import '../../common/const/appColorPicker.dart';
import '../../common/const/appPadding.dart';
import '../../common/provider/app_bar_title_provider.dart';
import '../my_page/view/my_page_screen.dart';

class MyData extends ConsumerWidget {
  const MyData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Stack 위젯을 사용하여 배경과 카드를 겹치게 배치
        Stack(
          children: [
            // 상단 배경 (darkBlueColor) 섹션
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                color: AppColors.darkBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.bottomLeftRight37,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(30.r, 24.r, 30.r, 24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 로고 및 메뉴 아이콘
                    Row(
                      children: [
                        Image.asset(
                          Assets.image.home.logo.path,
                          width: 120.r,
                          fit: BoxFit.contain,
                        ),
                        const Spacer(),
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () => Scaffold.of(context).openEndDrawer(),
                              child: Image.asset(
                                Assets.image.home.topMenu.path,
                                width: 30.r,
                                height: 30.r,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.r),
                    // 사용자 정보 카드
                    Container(
                      width: double.infinity,
                      padding: AppPaddings.home,
                      decoration: ShapeDecoration(
                        color: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorderRadius.radius15,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '홍길동 님.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.spMin,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  오늘도 화이팅하세요',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.spMin,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.pushNamed(MyPageScreen.routeName);
                                  ref.read(appBarTitleProvider.notifier).state =
                                      MyPageScreen.routeName;
                                },
                                color: Colors.white,
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.r),
                          Text(
                            '[사업운영본부] 경인지사 | 차장',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.r),
                          Text(
                            '사번 : 1001103 | 입사일 : 2018.01.15',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.r),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double horizontalGap = 20.r;
                        final double itemWidth =
                            (constraints.maxWidth - (horizontalGap * 2)) / 3;

                        return Wrap(
                          spacing: horizontalGap,
                          runSpacing: 20.r,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: itemWidth,
                              child: _buildMenuItem(
                                '급여명세서',
                                'asset/image/home/pay_stub.png',
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _buildMenuItem(
                                '민원접수',
                                'asset/image/home/complaint.png',
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _buildMenuItem(
                                '설문조사',
                                'asset/image/home/survey.png',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, String iconPath) {
    return Container(
      width: 127.r,
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.radius15),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.darkBlueColor,
              fontSize: 18.r,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(iconPath, width: 60.r, height: 60.r),
          ),
        ],
      ),
    );
  }
}
