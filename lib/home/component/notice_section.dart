import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/drawer/notice/provider/notice_provider.dart';
import 'package:lhens_app/drawer/notice/view/notice_screen.dart';
import 'package:lhens_app/home/component/home_notice_tile.dart';
import 'package:lhens_app/home/component/home_section_header.dart';

class NoticeSection extends ConsumerWidget {
  const NoticeSection({super.key, this.onTapPlus});

  final VoidCallback? onTapPlus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goNotice() => context.pushNamed(NoticeScreen.routeName);

    final notices = ref.watch(noticeProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(title: '공지사항', onTap: onTapPlus ?? goNotice),
          SizedBox(height: 8.h),
          if (notices is PagePagination)
            NoticeTile(
              isNew: true,
              title: notices.data[0].wrSubject,
              date: notices.data[0].wrDatetime,
              onTap: goNotice,
            ),
          if (notices is PagePagination)
            NoticeTile(
              title: notices.data[1].wrSubject,
              date: notices.data[1].wrDatetime,
              onTap: goNotice,
            ),
        ],
      ),
    );
  }
}
