// features/risk/view/risk_form_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold.dart';
import 'package:lhens_app/user/view/user_picker_screen.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class RiskFormScreen extends StatelessWidget {
  static String get routeName => '위험신고 등록';
  const RiskFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportFormScaffold(
      config: ReportFormConfig(
        titleHint: '제목',
        contentHint: '내용',
        typeItems: const ['전기','화재','설비','환경','기타'],
        showTargets: true,
        fixedTargets: const ['안전보건팀','임의지사'],
        onPickTargets: () async {
          final res = await context.pushNamed<UserPickResult>(UserPickerScreen.routeName);
          if (res == null) return null;
          return (depts: res.departments, users: res.members);
        },
        onSubmit: (v) {
          // TODO: 검증/전송
        },
      ),
    );
  }
}