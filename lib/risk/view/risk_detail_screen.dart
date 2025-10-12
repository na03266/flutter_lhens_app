import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';

class RiskDetailScreen extends ConsumerWidget {
  static String get routeName => '위험신고 상세';

  const RiskDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const type = '신고유형명';
    const title = '신고 제목이 표시되는 영역입니다. 신고 제목이 표시되는 영역입니다.';

    return ReportDetailScaffold(
      config: ReportDetailConfig(
        typeName: type,
        title: title,
        headerBuilder: (onMore) =>
            ReportDetailHeader(typeName: type, title: title, onMoreTap: onMore),
        metaRows: const [
          LabelValueLine.single(label1: '작성자', value1: '조예빈(1001599)'),
          LabelValueLine.single(label1: '등록일', value1: '2025. 08. 28'),
          LabelValueLine.single(label1: '진행상황', value1: '접수'),
          LabelValueLine.single(label1: '공개여부', value1: '공개'),
        ],
        body: const Text('내용이 표시되는\n영역입니다.'),
        attachments: const ['첨부파일명.pdf'],
        editRouteName: '위험신고 수정',
        myEditRouteName: '내 위험신고 수정',
      ),
    );
  }
}
