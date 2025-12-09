import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/utils/data_utils.dart';
import 'package:lhens_app/drawer/notice/view/notice_screen.dart';
import 'package:lhens_app/home/component/home_notice_tile.dart';
import 'package:lhens_app/home/component/home_section_header.dart';
import 'package:lhens_app/home/model/home_model.dart';
import 'package:lhens_app/home/provider/home_provider.dart';

class NoticeSection extends ConsumerWidget {
  const NoticeSection({super.key, this.onTapPlus});

  final VoidCallback? onTapPlus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void goNotice() => context.pushNamed(NoticeScreen.routeName);

    final state = ref.watch(homeProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(title: '공지 사항', onTap: onTapPlus ?? goNotice),
          SizedBox(height: 8.h),
          if (state is HomeModel && state.noticeItems.isNotEmpty)
            NoticeTile(
              isNew: true,
              title: state.noticeItems[0].wrSubject,
              date: DataUtils.datetimeParse(state.noticeItems[0].wrDatetime),
              onTap: goNotice,
            ),
          if (state is HomeModel && state.noticeItems.isNotEmpty)
            NoticeTile(
              title: state.noticeItems[1].wrSubject,
              date: DataUtils.datetimeParse(state.noticeItems[1].wrDatetime),
              onTap: goNotice,
            ),
          if (state is HomeModel && state.noticeItems.isNotEmpty)
            NoticeTile(
              title: state.noticeItems[2].wrSubject,
              date: DataUtils.datetimeParse(state.noticeItems[2].wrDatetime),
              onTap: goNotice,
            ),
          if (state is HomeModel && state.noticeItems.isNotEmpty)
            NoticeTile(
              title: state.noticeItems[3].wrSubject,
              date: DataUtils.datetimeParse(state.noticeItems[3].wrDatetime),
              onTap: goNotice,
            ),
        ],
      ),
    );
  }
}
