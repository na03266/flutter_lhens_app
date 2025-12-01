import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/report/editor_container.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';

class ReportFormScaffoldV2 extends StatefulWidget {
  final List<String> ca1Names;
  final List<String> ca2Names;
  final List<String> ca3Names;
  final PostDetailModel? post;
  final String submitText;
  final bool canEditSecret;
  final Function(CreatePostDto) onSubmit;

  const ReportFormScaffoldV2({
    super.key,
    this.ca1Names = const [],
    this.ca2Names = const [],
    this.ca3Names = const [],
    this.post,
    required this.submitText,
    this.canEditSecret = false,
    required this.onSubmit,
  });

  @override
  State<ReportFormScaffoldV2> createState() => _ReportFormScaffoldV2State();
}

class _ReportFormScaffoldV2State extends State<ReportFormScaffoldV2> {
  final _title = TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController(); // ★ 추가

  bool _secret = false;

  String? _ca1Name;
  String? _ca2Name;
  String? _ca3Name;

  @override
  void initState() {
    super.initState();
    _title.text = widget.post?.wrSubject ?? '';
    _ca1Name = widget.post?.caName;
    _ca2Name = widget.post?.wr1;
    _ca3Name = widget.post?.wr2;
    _secret = widget.post?.wrOption.contains('secret') ?? false;
  }

  Future<bool> get _canSubmit async {
    final t = _title.text.trim();
    final c = await _htmlController.getText();
    return t.isNotEmpty && c.isNotEmpty;
  }

  _submit() async {
    if (await _canSubmit) {
      widget.onSubmit(
        CreatePostDto(
          wrSubject: _title.text.trim(),
          wrContent: await _htmlController.getText(),
          wrOption: _secret ? 'html1,secret' : 'html1',
          caName: _ca1Name,
          wr1: _ca2Name,
          wr2: _ca3Name,
        ),
      );
    }
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
              if (widget.ca1Names.isNotEmpty) ...[
                Selector<String>(
                  hint: '유형1 선택',
                  items: widget.ca1Names,
                  selected: _ca1Name,
                  getLabel: (v) => v,
                  onSelected: (v) => setState(() {
                    if (v == '외부 공지사항' || v == '내부 공지사항') {
                      _ca2Name = null;
                    }
                    _ca1Name = v;
                  }),
                ),
                SizedBox(height: 12.h),
              ],
              if (widget.ca2Names.isNotEmpty) ...[
                Selector<String>(
                  hint: '유형2 선택',
                  items: _ca1Name != '외부 공지사항'
                      ? widget.ca2Names
                            .where((e) => !['공고문', '언론보도'].contains(e))
                            .toList()
                      : widget.ca2Names
                            .where((e) => ['공고문', '언론보도'].contains(e))
                            .toList(),
                  selected: _ca2Name,
                  getLabel: (v) => v,
                  onSelected: (v) => setState(() {
                    if (['공고문', '언론보도'].contains(v)) {}
                    _ca2Name = v;
                  }),
                ),
                SizedBox(height: 12.h),
              ],
              if (widget.ca3Names.isNotEmpty) ...[
                Selector<String>(
                  hint: '유형3 선택',
                  items: widget.ca3Names,
                  selected: _ca3Name,
                  getLabel: (v) => v,
                  onSelected: (v) => setState(() {
                    _ca3Name = v;
                  }),
                ),
                SizedBox(height: 12.h),
              ],

              // 제목
              AppTextField(
                hint: '제목',
                controller: _title,
                textInputAction: TextInputAction.next,
                dimOnLocked: false,
              ),
              SizedBox(height: 12.h),

              // 내용
              EditorContainer(
                height: 248,
                showCounter: false,
                // HTML 기준 글자수는 저장 시 계산 권장
                dimOnLocked: false,
                child: HtmlEditor(
                  controller: _htmlController,
                  htmlEditorOptions: HtmlEditorOptions(
                    initialText: widget.post?.wrContent ?? '',
                  ),
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    toolbarType: ToolbarType.nativeGrid,
                    defaultToolbarButtons: [
                      InsertButtons(
                        link: true,
                        picture: true,
                        audio: false,
                        video: false,
                        table: false,
                        hr: false,
                      ),
                      //
                    ],
                  ),
                  otherOptions: const OtherOptions(height: 230),
                  callbacks: Callbacks(
                    onImageUpload: (file) async {
                      final base64Str =
                          file.base64; // 예: "data:image/png;base64,AAAA..."
                      final filename = file.name;

                      if (base64Str == null || filename == null) return;

                      // 1) "data:image/png;base64," 부분 제거
                      final reg = RegExp(r'data:image/[^;]+;base64,');
                      final pureBase64 = base64Str.replaceAll(reg, '');

                      // 2) base64 → Uint8List 디코딩
                      final Uint8List bytes = base64Decode(pureBase64);

                      if (bytes == null || filename == null) return;

                      // 2. 서버로 업로드 (예: NestJS /upload/editor-image)
                      final imageUrl = null;
                      // await _uploadEditorImage(
                      //   bytes,
                      //   filename,
                      // );

                      // 3. 에디터에 네트워크 이미지로 삽입
                      if (imageUrl != null) {
                        _htmlController.insertNetworkImage(imageUrl);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.h),

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

              AppButton(
                text: widget.submitText,
                onTap: () => _submit(),
                type: AppButtonType.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
