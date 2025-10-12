import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/drawer/notice/view/notice_screen.dart';
import 'package:lhens_app/home/component/home_notice_tile.dart';
import 'package:lhens_app/home/component/home_section_header.dart';

class NoticeSection extends StatelessWidget {
  const NoticeSection({super.key, this.onTapPlus});

  final VoidCallback? onTapPlus;

  @override
  Widget build(BuildContext context) {
    void goNotice() => context.pushNamed(NoticeScreen.routeName);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(title: '공지사항', onTap: onTapPlus ?? goNotice),
          SizedBox(height: 8.h),

          NoticeTile(
            isNew: true,
            title: '2025년 05월 25일 업데이트 및 점검',
            date: '2025.01.01',
            onTap: goNotice,
          ),
          NoticeTile(
            title: '2025년 05월 25일 업데이트 및 점검',
            date: '2025.01.01',
            onTap: goNotice,
          ),
        ],
      ),
    );
  }
}
