import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/editor_container.dart';
import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/sections/attchment_section.dart';
import 'package:lhens_app/common/components/sections/target_section.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/components/text_editor_adapter.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/user/view/user_picker_screen.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class RiskFormScreen extends StatefulWidget {
  static String get routeName => '위험신고 등록';

  const RiskFormScreen({super.key});

  @override
  State<RiskFormScreen> createState() => _RiskFormScreenState();
}

class _RiskFormScreenState extends State<RiskFormScreen> {
  final _title = TextEditingController();
  final _content = TextEditingController();

  final _types = const ['전기', '화재', '설비', '환경', '기타'];
  String? _type;
  bool _secret = true;

  // 첨부 파일명 리스트
  final List<String> _files = ['첨부파일_1.pdf', '첨부파일_2.pdf'];

  // 사용자 선택 결과 (사용자 선택 화면에서 반환)
  List<String> _pickedDepts = [];
  List<String> _pickedUsers = [];

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _submit() {
    // TODO: 검증 & 등록
  }

  void _addFile() {
    // TODO: 기기 파일 피커 연동
    setState(() {
      _files.add('첨부파일_${_files.length + 1}.pdf');
    });
  }

  void _removeFile(String name) {
    setState(() {
      _files.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 유형
              Selector<String>(
                hint: '유형 선택',
                items: _types,
                selected: _type,
                getLabel: (v) => v,
                onSelected: (v) => setState(() => _type = v),
              ),
              SizedBox(height: 12.h),

              // 제목
              AppTextField(
                hint: '제목',
                controller: _title,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 12.h),

              // 내용
              EditorContainer(
                height: 248,
                showCounter: true,
                counterText: '${_content.text.characters.length}/600',
                // TODO: TextEditorAdapter → 실제 리치 텍스트 에디터로 교체
                child: TextEditorAdapter(
                  controller: _content,
                  hint: '내용',
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(height: 4.h),

              // 비공개
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppCheckbox(
                    label: '비공개',
                    value: _secret,
                    onChanged: (v) => setState(() => _secret = v),
                    style: AppCheckboxStyle.secondary,
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // 파일 첨부 섹션
              AttachmentSection(
                files: _files,
                onAdd: _addFile,
                onRemove: _removeFile,
                spacing: 8,
              ),
              SizedBox(height: 24.h),

              // 알림 대상 섹션
              TargetSection<String>(
                onSearch: () async {
                  final res = await context.pushNamed<UserPickResult>(UserPickerScreen.routeName);
                  if (res != null) {
                    setState(() {
                      _pickedDepts = res.departments;
                      _pickedUsers = res.members;
                    });
                  }
                },
                getText: (s) => s,
                fixed: const ['안전보건팀', '임의지사'],
                groups: [
                  TargetGroup(label: '본부', items: _pickedDepts),
                  TargetGroup(label: '직원', items: _pickedUsers),
                ],
                onRemove: (group, item) {
                  if (group == '직원') {
                    setState(() => _pickedUsers.remove(item));
                  } else if (group == '본부') {
                    setState(() => _pickedDepts.remove(item));
                  }
                },
              ),
              SizedBox(height: 32.h),

              // 등록 버튼
              AppButton(
                text: '등록',
                onTap: _submit,
                type: AppButtonType.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
