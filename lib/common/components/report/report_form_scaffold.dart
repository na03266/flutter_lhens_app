import 'dart:math' as math;
import 'package:characters/characters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/report/editor_container.dart';
import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/report/status_segmented.dart';
import 'package:lhens_app/common/components/attachments/attchment_section.dart';
import 'package:lhens_app/user/component/target_section.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/components/report/text_editor_adapter.dart';
import 'package:lhens_app/common/components/report/report_form_config.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class ReportFormScaffold extends StatefulWidget {
  final ReportFormConfig config;

  const ReportFormScaffold({super.key, required this.config});

  @override
  State<ReportFormScaffold> createState() => _ReportFormScaffoldState();
}

class _ReportFormScaffoldState extends State<ReportFormScaffold> {
  static const int _maxContentLen = 600;
  final _title = TextEditingController();
  final _content = TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController();  // ★ 추가

  String? _type;
  String? _status;
  bool _secret = true;

  final List<String> _files = [];
  List<String> _pickedDepts = [];
  List<String> _pickedUsers = [];

  @override
  void initState() {
    super.initState();
    final c = widget.config;
    _type = c.initialType;
    _status = c.selectedStatus;
    _title.text = c.initialTitle ?? '';
    _content.text = c.initialContent ?? '';
    _secret = c.initialSecret ?? true;
    _files.addAll(c.initialFiles);
    _pickedDepts = List.of(c.initialTargetDepts);
    _pickedUsers = List.of(c.initialTargetUsers);
    // HTML 에디터 초기값 (c.initialContent 가 HTML이라면 그대로 사용)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (c.initialContent != null && c.initialContent!.isNotEmpty) {
        _htmlController.setText(c.initialContent!);
      }
    });
  }

  bool get _doneLocked => widget.config.isEdit && _status == '완료';

  bool get _locked =>
      _doneLocked || widget.config.lockMode != FormLockMode.none;

  bool get _canSubmit {
    final t = _title.text.trim();
    final c = _content.text.trim();
    return t.isNotEmpty && c.isNotEmpty;
  }

  void _enforceContentMax() {
    final chars = _content.text.characters;
    if (chars.length > _maxContentLen) {
      final trimmed = chars.take(_maxContentLen).toString();
      final sel = _content.selection;
      final newOffset = math.min(sel.baseOffset, trimmed.characters.length);
      _content.value = TextEditingValue(
        text: trimmed,
        selection: TextSelection.collapsed(offset: newOffset),
      );
    }
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
        status: _status,
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
              // 진행상태
              if (cfg.isEdit) ...[
                IgnorePointer(
                  ignoring: !cfg.canEditStatus,
                  child: Opacity(
                    opacity: cfg.canEditStatus ? 1 : 0.6,
                    child: StatusSegmented(
                      value: switch (_status) {
                        '처리중' => ReportStatus.processing,
                        '완료' => ReportStatus.done,
                        _ => ReportStatus.received,
                      },
                      onChanged: (s) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _status = switch (s) {
                            ReportStatus.processing => '처리중',
                            ReportStatus.done => '완료',
                            _ => '접수',
                          };
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],

              // 유형
              IgnorePointer(
                ignoring: _locked,
                child: Opacity(
                  opacity: _locked ? 0.6 : 1,
                  child: Selector<String>(
                    hint: '유형 선택',
                    items: cfg.typeItems,
                    selected: _type,
                    getLabel: (v) => v,
                    onSelected: (v) => setState(() => _type = v),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // 제목
              AppTextField(
                hint: cfg.titleHint,
                controller: _title,
                textInputAction: TextInputAction.next,
                locked: _locked,
                dimOnLocked: false,
              ),
              SizedBox(height: 12.h),

              // 내용
              EditorContainer(
                height: 248,
                showCounter: true,
                // 단순 길이 카운터를 유지하려면 컨텐츠를 가져와서 계산해야 함
                counterText: '',
                // 일단 비워두거나, 필요하면 별도 처리
                locked: _locked,
                dimOnLocked: false,
                child: IgnorePointer(
                  ignoring: _locked,
                  child: Opacity(
                    opacity: _locked ? 0.6 : 1,
                    child: HtmlEditor(
                      controller: _htmlController,
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: cfg.contentHint,
                        // 초기 HTML은 initState에서 setText로 넣으므로 여기선 생략 가능
                        // initialText: widget.config.initialContent ?? '',
                      ),
                      htmlToolbarOptions: const HtmlToolbarOptions(
                        toolbarType: ToolbarType.nativeScrollable,
                      ),
                      otherOptions: const OtherOptions(height: 230),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // 비공개
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IgnorePointer(
                    ignoring: !cfg.canEditSecret,
                    child: Opacity(
                      opacity: cfg.canEditSecret ? 1 : 0.6,
                      child: AppCheckbox(
                        label: '비공개',
                        value: _secret,
                        onChanged: (v) => setState(() => _secret = v),
                        style: AppCheckboxStyle.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // 첨부
              IgnorePointer(
                ignoring: _locked,
                child: Opacity(
                  opacity: _locked ? 0.7 : 1,
                  child: AttachmentSection(
                    files: _files,
                    onAdd: () => setState(() {
                      _files.add('첨부_${_files.length + 1}.pdf');
                    }),
                    onRemove: (name) => setState(() {
                      _files.remove(name);
                    }),
                    spacing: 8,
                  ),
                ),
              ),

              if (cfg.showTargets) ...[
                SizedBox(height: 24.h),
                IgnorePointer(
                  ignoring: _locked,
                  child: Opacity(
                    opacity: _locked ? 0.6 : 1,
                    child: TargetSection<String>(
                      onSearch: () async {
                        if (cfg.onPickTargets == null) return;
                        final res = await cfg.onPickTargets!();
                        if (res != null) {
                          setState(() {
                            _pickedDepts = res.depts;
                            _pickedUsers = res.users;
                          });
                        }
                      },
                      getText: (s) => s,
                      fixed: cfg.fixedTargets,
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
                  ),
                ),
              ],

              SizedBox(height: 32.h),

              AppButton(
                text: cfg.submitText,
                onTap: _canSubmit ? _submit : null,
                type: AppButtonType.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
