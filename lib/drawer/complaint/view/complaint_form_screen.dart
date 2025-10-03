// features/complaint/view/complaint_form_screen.dart
import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold.dart';

class ComplaintFormScreen extends StatelessWidget {
  static String get routeName => '민원제안 작성';
  const ComplaintFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportFormScaffold(
      config: ReportFormConfig(
        titleHint: '제목',
        contentHint: '내용',
        typeItems: const ['불편','개선','문의','제안','기타'],
        showTargets: false,
        onSubmit: (v) {
          // TODO: 검증/전송
        },
      ),
    );
  }
}