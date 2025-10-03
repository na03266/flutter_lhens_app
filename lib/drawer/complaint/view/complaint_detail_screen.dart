import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';

class ComplaintDetailScreen extends StatelessWidget {
  static String get routeName => '민원제안 상세';
  const ComplaintDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportDetailScaffold(
      config: ReportDetailConfig(
        typeName: '민원유형명',
        title: '접수 제목이 표시되는 영역입니다. 접수 제목이 표시되는 영역입니다. 접수 제목이 표시되는 영역입니다.',
        metaRows: const [
          LabelValueLine.single(label1: '작성자', value1: '조예빈(1001599)'),
          LabelValueLine.single(label1: '등록일', value1: '2025. 09. 01'),
          LabelValueLine.single(label1: '처리상태', value1: '대기'),
          LabelValueLine.single(label1: '공개여부', value1: '공개'),
        ],
        body: const Text('민원/제안 본문 내용입니다.\n업무 개선 제안 상세가 들어갑니다.'),
        attachments: const ['참고자료.docx'],
        editRouteName: '민원제안 작성',     // ComplaintFormScreen.routeName
        myEditRouteName: '내 민원제안 수정', // 필요 없으면 null
      ),
    );
  }
}