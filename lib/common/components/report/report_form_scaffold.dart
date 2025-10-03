import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/editor_container.dart';
import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/sections/attchment_section.dart';
import 'package:lhens_app/common/components/sections/target_section.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/components/text_editor_adapter.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class ReportFormConfig {
  final String titleHint;
  final String contentHint;
  final List<String> typeItems;
  final bool showTargets; // ← 차이점 토글
  final Future<({List<String> depts, List<String> users})?> Function()?
  onPickTargets;
  final List<String> fixedTargets;
  final String submitText;
  final void Function(ReportFormValue value) onSubmit;

  const ReportFormConfig({
    required this.titleHint,
    required this.contentHint,
    required this.typeItems,
    required this.showTargets,
    this.onPickTargets,
    this.fixedTargets = const [],
    this.submitText = '등록',
    required this.onSubmit,
  });
}

class ReportFormValue {
  final String? type;
  final String title;
  final String content;
  final bool secret;
  final List<String> files;
  final List<String> targetDepts;
  final List<String> targetUsers;

  const ReportFormValue({
    required this.type,
    required this.title,
    required this.content,
    required this.secret,
    required this.files,
    required this.targetDepts,
    required this.targetUsers,
  });
}

class ReportFormScaffold extends StatefulWidget {
  final ReportFormConfig config;

  const ReportFormScaffold({super.key, required this.config});

  @override
  State<ReportFormScaffold> createState() => _ReportFormScaffoldState();
}

class _ReportFormScaffoldState extends State<ReportFormScaffold> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  String? _type;
  bool _secret = true;
  final List<String> _files = [];
  List<String> _pickedDepts = [];
  List<String> _pickedUsers = [];

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _submit() {
    widget.config.onSubmit(
      ReportFormValue(
        type: _type,
        title: _title.text.trim(),
        content: _content.text.trim(),
        secret: _secret,
        files: List.unmodifiable(_files),
        targetDepts: List.unmodifiable(_pickedDepts),
        targetUsers: List.unmodifiable(_pickedUsers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
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
              Selector<String>(
                hint: '유형 선택',
                items: cfg.typeItems,
                selected: _type,
                getLabel: (v) => v,
                onSelected: (v) => setState(() => _type = v),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                hint: cfg.titleHint,
                controller: _title,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 12.h),
              EditorContainer(
                height: 248,
                showCounter: true,
                counterText: '${_content.text.characters.length}/600',
                child: TextEditorAdapter(
                  controller: _content,
                  hint: cfg.contentHint,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(height: 4.h),
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
              AttachmentSection(
                files: _files,
                onAdd: () =>
                    setState(() => _files.add('첨부_${_files.length + 1}.pdf')),
                onRemove: (name) => setState(() => _files.remove(name)),
                spacing: 8,
              ),
              if (cfg.showTargets) ...[
                SizedBox(height: 24.h),
                TargetSection<String>(
                  onSearch: () async {
                    if (cfg.onPickTargets == null) return;
                    final res = await cfg.onPickTargets!();
                    if (res != null)
                      setState(() {
                        _pickedDepts = res.depts;
                        _pickedUsers = res.users;
                      });
                  },
                  getText: (s) => s,
                  fixed: cfg.fixedTargets,
                  groups: [
                    TargetGroup(label: '본부', items: _pickedDepts),
                    TargetGroup(label: '직원', items: _pickedUsers),
                  ],
                  onRemove: (group, item) {
                    if (group == '직원')
                      setState(() => _pickedUsers.remove(item));
                    if (group == '본부')
                      setState(() => _pickedDepts.remove(item));
                  },
                ),
              ],
              SizedBox(height: 32.h),
              AppButton(
                text: cfg.submitText,
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
