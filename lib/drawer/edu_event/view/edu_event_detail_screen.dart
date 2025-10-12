import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class EduEventDetailScreen extends ConsumerWidget {
  static String get routeName => '교육행사 상세';

  const EduEventDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const type = '교육행사정보';
    const title = '2025 안전보건 규정 변경 및 실무교육';

    return ReportDetailScaffold(
      config: ReportDetailConfig(
        typeName: type,
        title: title,
        headerBuilder: (onMore) =>
            ReportDetailHeader(typeName: type, title: title, onMoreTap: onMore),
        metaRows: const [
          LabelValueLine.single(label1: '수신부서', value1: '기획조정실 안전보건팀'),
          LabelValueLine.single(label1: '기간', value1: '2025. 01. 15 ~ 2025. 01. 16'),
        ],
        body: _EduEventBody(),
        attachments: const ['첨부파일명.pdf'],
        editRouteName: '교육행사 수정',
        showComments: false,
        showBackToListButton: true,
        onBackToList: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _EduEventBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: AppTextStyles.pr16.copyWith(color: AppColors.text, height: 1.5),
      child: const Text(
        '교육/행사에 대한 상세 내용이 표시되는 영역입니다.\n\n'
        '본 문구는 임시 데이터이며 실제 데이터 연동 시 대체됩니다.',
      ),
    );
  }
}
