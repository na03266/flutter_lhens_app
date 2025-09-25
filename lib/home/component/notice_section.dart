import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/home/component/home_notice_tile.dart';
import 'package:lhens_app/home/component/home_section_header.dart';

class NoticeSection extends StatelessWidget {
  const NoticeSection({super.key, this.onTapPlus});

  final VoidCallback? onTapPlus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(title: '공지사항', onTap: onTapPlus ?? () {}),
          SizedBox(height: 8.h),

          const NoticeTile(
            isNew: true,
            title: '2025년 05월 25일 업데이트 및 점검',
            date: '2025.01.01',
          ),
          const NoticeTile(
            title: '2025년 05월 25일 업데이트 및 점검',
            date: '2025.01.01',
          ),
        ],
      ),
    );
  }
}
