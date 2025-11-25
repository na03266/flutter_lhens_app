import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/drawer/complaint/provider/complaint_provider.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '민원제안 상세';
  final String wrId;

  const ComplaintDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<ComplaintDetailScreen> createState() =>
      _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(complaintProvider.notifier).getDetail(wrId: widget.wrId);
  }

  @override
  Widget build(BuildContext context) {
    const type = '민원제안유형명';
    const title = '민원 제목이 표시되는 영역입니다. 민원 제목이 표시되는 영역입니다.';

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
        editRouteName: '민원제안 수정',
        myEditRouteName: '내 민원제안 수정',
      ),
    );
  }
}
