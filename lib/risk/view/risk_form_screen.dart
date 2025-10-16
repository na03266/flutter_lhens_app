import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_form_config.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold.dart';
import 'package:lhens_app/user/view/user_picker_screen.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class RiskFormScreen extends StatelessWidget {
  static String get routeName => '위험신고 등록';

  const RiskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final isEdit = state.name == '위험신고 수정' || state.name == '내 위험신고 수정';

    // 임시 초기값
    final initialType = isEdit ? '신고유형명' : null;
    final initialTitle = isEdit
        ? '신고 제목이 표시되는 영역입니다. 신고 제목이 표시되는 영역입니다.'
        : null;
    final initialContent = isEdit ? '내용이 표시되는\n영역입니다.' : null;
    final initialFiles = isEdit ? const ['첨부파일명.pdf'] : const <String>[];

    final userPickerRouteName = isEdit
        ? '위험신고수정-사용자선택'
        : UserPickerScreen.routeName;

    return ReportFormScaffold(
      config: ReportFormConfig(
        titleHint: '제목',
        contentHint: '내용',
        typeItems: const ['신고유형명', '신고유형명2', '신고유형명3'],
        showTargets: true,
        fixedTargets: const ['안전보건팀', '임의지사'],
        onPickTargets: () async {
          // 현재 위치 기준으로 상대경로 이동
          final base = GoRouterState.of(context).matchedLocation; // /risk/form 또는 /risk/edit
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
        onSubmit: (v) {
          // 저장 완료 스낵바
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('저장되었습니다.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black87,
              duration: const Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            ),
          );

          // 페이지 닫기
          Navigator.pop(context);
        },
      ),
    );
  }
}
