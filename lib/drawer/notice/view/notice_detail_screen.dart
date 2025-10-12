import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class NoticeDetailScreen extends ConsumerWidget {
  static String get routeName => '공지사항 상세';

  const NoticeDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const type = '외부공지사항';
    const title = "[보도자료] LH E&S, 폭염 속 '온열질환 예방'에 총력";

    return ReportDetailScaffold(
      config: ReportDetailConfig(
        typeName: type,
        title: title,
        headerBuilder: (onMore) =>
            ReportDetailHeader(typeName: type, title: title, onMoreTap: null),
        metaRows: const [
          LabelValueLine.single(label1: '작성자', value1: '조예빈(1001599)'),
          LabelValueLine.single(label1: '등록일', value1: '2025. 08. 28'),
          LabelValueLine.single(label1: '조회수', value1: '317'),
        ],
        body: _NoticeBody(),
        attachments: const ['첨부파일명.pdf'],
        editRouteName: '공지사항 수정', // 편집 라우트가 아직 없으면 사용되지 않음
        showComments: false,
        showBackToListButton: true,
        onBackToList: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _NoticeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: AspectRatio(
            aspectRatio: 356 / 267,
            child: Image.asset(
              Assets.images.notice.path,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        // 본문 텍스트
        DefaultTextStyle.merge(
          style: AppTextStyles.pr16.copyWith(
            color: AppColors.text,
            height: 1.5,
          ),
          child: const Text(
            "한국토지주택공사(LH)의 자회사인 (주)LH E&S(대표이사 김규명)는 2025년 8월 한 달간 전국 23개 사업소에서 옥외근로자를 대상으로 ‘온열질환자 긴급구조 훈련’을 실시했다.\n\n"
            "이번 훈련은 연일 지속되는 폭염으로 온열질환 발생 위험이 높아짐에 따라 실시한 것으로 온열질환자 발생을 가정하여 긴급구조 및 응급처치 훈련에 이어, 온열질환 예방을 위한 건강관리 방법을 교육하는 순으로 진행되었다.\n\n"
            "훈련 참가자들은 온열질환자 발생상황을 생동감 있게 재현하며, 체계적이고 신속한 대응 절차를 숙달함으로써 현장 대응 역량을 높였다.\n\n"
            "(주)LH E&S는 최근 산업안전보건위원회를 통해 옥외근로자에게 냉각조끼 지급을 의결하고, 각종 온열질환 예방용품을 배포하는 등 폭염에 의한 근로자 건강 보호를 위한 조치를 강화했다.\n\n"
            "김규명 대표이사는 “이번 훈련을 통해 근로자의 안전과 건강이 회사 경영의 최우선 가치임을 다시금 강조드리며, 이를 바탕으로 공공안전에도 이바지할 수 있다”라며 안전보건경영에 대한 강한 의지를 밝혔다.",
          ),
        ),
      ],
    );
  }
}