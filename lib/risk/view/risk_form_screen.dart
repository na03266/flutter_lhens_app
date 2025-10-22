import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_form_config.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class RiskFormScreen extends StatelessWidget {
  static String get routeName => '위험신고 등록';

  const RiskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final isEdit = state.name == '위험신고 수정' || state.name == '내 위험신고 수정';

    final initialType = isEdit ? '신고유형명' : null;
    final initialTitle = isEdit
        ? '신고 제목이 표시되는 영역입니다. 신고 제목이 표시되는 영역입니다.'
        : null;
    final initialContent = isEdit ? '내용이 표시되는\n영역입니다.' : null;
    final initialFiles = isEdit ? const ['첨부파일명.pdf'] : const <String>[];

    return ReportFormScaffold(
      config: ReportFormConfig(
        titleHint: '제목',
        contentHint: '내용',
        typeItems: const ['신고유형명', '신고유형명2', '신고유형명3'],
        showTargets: true,
        fixedTargets: const ['안전보건팀', '임의지사'],
        onPickTargets: () async {
          final base = GoRouterState.of(context).matchedLocation;
          final res = await context.push<UserPickResult>('$base/user-picker');
          if (res == null) return null;
          return (depts: res.departments, users: res.members);
        },
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
