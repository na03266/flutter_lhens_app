import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/status_chip.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/utils/data_utils.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/gen/assets.gen.dart';

// 상태 구분 (필요한 경우만 사용)
enum ItemStatus { received, processing, done }

class BaseListItem extends StatelessWidget {
  final ItemStatus? status; // 상태칩 (선택)
  final String typeName; // 유형명
  final String title;
  final String author; // 작성자
  final String dateText; // 등록일
  final int? commentCount; // 댓글 수 (선택)
  final bool secret; // 비밀글 여부 (선택)
  final VoidCallback? onTap;
  final bool isEdu;

  const BaseListItem({
    super.key,
    this.status,
    required this.typeName,
    required this.title,
    required this.author,
    required this.dateText,
    this.commentCount,
    this.secret = false,
    this.isEdu = false,
    this.onTap,
  });

  factory BaseListItem.fromPostModel({
    required PostModel model,
    bool isDetail = false,
  }) {
    return BaseListItem(
      typeName: '${model.caName} ${model.wr1 == '' ? '' : '[${model.wr1}]'} ',
      title: model.wrSubject,
      author: model.wrName,
      dateText: DataUtils.datetimeParse(model.wrDatetime),
    );
  }

  factory BaseListItem.fromPostModelForEdu({
    required PostModel model,
    bool isDetail = false,
  }) {
    return BaseListItem(
      isEdu: true,
      typeName: model.caName,
      title: model.wrSubject,
      author: model.wr3,
      dateText: model.wr4,
    );
  }

  factory BaseListItem.fromPostModelForComplaint({
    required PostModel model,
    bool isDetail = false,
  }) {
    return BaseListItem(
      status: model.wr2 == '접수'
          ? ItemStatus.received
          : model.wr2 == '처리중'
          ? ItemStatus.processing
          : ItemStatus.done,
      secret: model.wrOption.contains('secret'),
      typeName: model.caName,
      title: model.wrSubject,
      author: model.wrName,
      dateText: DataUtils.datetimeParse(model.wrDatetime),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상태칩 / 비밀글
                if (status != null || secret)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (status != null) StatusChip(type: _mapStatus(status!)),
                      const Spacer(),
                      if (secret)
                        Assets.icons.lock.svg(width: 22.w, height: 22.w),
                    ],
                  ),

                if (status != null || secret) SizedBox(height: 12.h),

                // 유형명
                Text(
                  typeName,
                  style: AppTextStyles.pm13.copyWith(color: AppColors.textSec),
                ),
                SizedBox(height: 6.h),

                // 제목
                Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.pm16.copyWith(
                    color: AppColors.text,
                    height: 1.35,
                    letterSpacing: -0.40,
                  ),
                ),
                SizedBox(height: 10.h),

                // 작성자 · 날짜 · (댓글)
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdu ? '수신부서' : author,
                          style: AppTextStyles.pr13.copyWith(
                            color: AppColors.textTer,
                          ),
                        ),
                        if (isEdu) ...[
                          SizedBox(height: 5.h),
                          Text(
                            '기간',
                            style: AppTextStyles.pr13.copyWith(
                              color: AppColors.textTer,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdu ? author : dateText,
                          style: AppTextStyles.pr13.copyWith(
                            color: AppColors.textTer,
                          ),
                        ),
                        if (isEdu) ...[
                          SizedBox(height: 5.h),
                          Text(
                            dateText,
                            style: AppTextStyles.pr13.copyWith(
                              color: AppColors.textTer,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (commentCount != null) ...[
                      SizedBox(width: 8.w),
                      Transform.translate(
                        offset: Offset(0, 1.h),
                        child: Assets.icons.comment.svg(
                          width: 16.w,
                          height: 16.w,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${commentCount ?? 0}',
                        style: AppTextStyles.pb11.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // 하단 구분선
          Container(
            margin: EdgeInsets.only(top: 16.h, bottom: 10.h),
            height: 1,
            color: AppColors.borderStrong,
          ),
        ],
      ),
    );
  }

  StatusChipType _mapStatus(ItemStatus s) {
    switch (s) {
      case ItemStatus.received:
        return StatusChipType.received;
      case ItemStatus.processing:
        return StatusChipType.processing;
      case ItemStatus.done:
        return StatusChipType.done;
    }
  }
}
