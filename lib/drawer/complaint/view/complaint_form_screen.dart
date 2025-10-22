import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_form_config.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold.dart';

class ComplaintFormScreen extends StatelessWidget {
  static String get routeName => '민원제안 등록';

  const ComplaintFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final isEdit = state.name == '민원제안 수정' || state.name == '내 민원제안 수정';

    final initialType = isEdit ? '민원제안유형명' : null;
    final initialTitle = isEdit
        ? '민원 제목이 표시되는 영역입니다. 민원 제목이 표시되는 영역입니다.'
        : null;
    final initialContent = isEdit ? '내용이 표시되는\n영역입니다.' : null;
    final initialFiles = isEdit ? const ['첨부파일명.pdf'] : const <String>[];

    return ReportFormScaffold(
      config: ReportFormConfig(
        titleHint: '제목',
        contentHint: '내용',
        typeItems: const ['민원제안유형명', '민원제안유형명2', '민원제안유형명3'],
        showTargets: false,
        isEdit: isEdit,
        submitText: isEdit ? '저장' : '등록',
        canEditStatus: isEdit,
        canEditSecret: true,
        statusItems: const ['접수', '처리중', '완료'],
        initialType: initialType,
        initialTitle: initialTitle,
        initialContent: initialContent,
        initialFiles: initialFiles,
        onSubmit: (v) async {
          // TODO: 저장 처리
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
