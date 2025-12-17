import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:lhens_app/common/components/attachments/attchment_section.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/selector/selector.dart';
import 'package:lhens_app/common/file/model/file_model.dart';
import 'package:lhens_app/common/file/model/temp_file_model.dart';
import 'package:lhens_app/common/file/repository/file_repository.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';

class ReportFormScaffoldV2 extends ConsumerStatefulWidget {
  final List<String> ca1Names;
  final List<String> ca2Names;
  final List<String> ca3Names;
  final PostDetailModel? post;
  final String submitText;
  final bool canEditSecret;
  final bool isEduEvent;
  final Function(CreatePostDto) onSubmit;

  const ReportFormScaffoldV2({
    super.key,
    this.ca1Names = const [],
    this.ca2Names = const [],
    this.ca3Names = const [],
    this.post,
    required this.submitText,
    this.isEduEvent = false,
    this.canEditSecret = false,
    required this.onSubmit,
  });

  @override
  ConsumerState<ReportFormScaffoldV2> createState() =>
      _ReportFormScaffoldV2State();
}

class _ReportFormScaffoldV2State extends ConsumerState<ReportFormScaffoldV2> {
  final _title = TextEditingController();
  final _wr4 = TextEditingController();
  final HtmlEditorController _htmlController = HtmlEditorController(); // ★ 추가

  bool _secret = false;

  String? _ca1Name;
  String? _ca2Name;
  String? _ca3Name;

  List<FileModel> _oldFiles = [];
  Set<int> _keepFileIds = {}; // 유지할 기존 파일의 bfNo

  List<TempFileModel> _newFiles = [];

  String? _thumbnailUrl;

  @override
  void initState() {
    super.initState();
    _title.text = widget.post?.wrSubject ?? '';
    _ca1Name = widget.post?.caName;
    _ca2Name = widget.post?.wr1;
    _ca3Name = widget.post?.wr2;
    _secret = widget.post?.wrOption.contains('secret') ?? false;
    // 기존 첨부파일이 있다면 초기화
    _thumbnailUrl = widget.post?.wr5;
    if (widget.post?.files != null) {
      _oldFiles = widget.post!.files;
      // 초기에는 모든 기존 파일을 유지
      _keepFileIds = _oldFiles.map((f) => f.bfNo).toSet();
    }
  }

  // 썸네일 선택 및 업로드 (wr5 전용)
  Future<void> _pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result == null || result.files.isEmpty) return;

    final platformFile = result.files.first;
    if (platformFile.path == null) return;

    try {
      final file = File(platformFile.path!);

      final responseUrl = await ref
          .read(fileRepositoryProvider)
          .uploadThumbnail(file: file); // TempFileModel 반환이라고 가정

      // ★ 업로드 결과에서 URL만 wr5용으로 사용
      setState(() {
        _thumbnailUrl = responseUrl; // 필드 이름은 TempFileModel에 맞게 수정
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('썸네일 업로드 실패.')));
    }
  }

  void _removeThumbnail() {
    setState(() {
      _thumbnailUrl = null;
    });
  }

  Future<bool> get _canSubmit async {
    final t = _title.text.trim();
    final c = await _htmlController.getText();
    return t.isNotEmpty && c.isNotEmpty;
  }

  // 파일 선택 및 업로드
  Future<void> _pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result == null || result.files.isEmpty) return;

    for (final platformFile in result.files) {
      // path가 없으면 (웹 환경 등) 스킵
      if (platformFile.path == null) continue;

      try {
        // PlatformFile -> File 변환
        final file = File(platformFile.path!);

        // 서버에 업로드
        final uploadedFile = await ref
            .read(fileRepositoryProvider)
            .uploadFile(file: file);

        setState(() {
          _newFiles.add(uploadedFile);
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('파일 업로드 실패.')));
      }
    }
  }

  // 기존 파일 제거 (keepFileIds에서 제외)
  void _removeOldFile(int bfNo) {
    setState(() {
      _keepFileIds.remove(bfNo);
    });
  }

  // 새 파일 제거
  void _removeNewFile(String savedName) {
    setState(() {
      _newFiles.removeWhere((f) => f.savedName == savedName);
    });
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
          // todo 조직도
          wr3: "전체",
          wr4: widget.isEduEvent ? _wr4.text.trim() : null,
          wr5: _thumbnailUrl,
          files: widget.submitText == '등록' && _newFiles.isNotEmpty
              ? _newFiles
              : null,
          keepFiles: widget.submitText == '수정' && _keepFileIds.isNotEmpty
              ? _keepFileIds.toList()
              : null,
          newFiles: widget.submitText == '수정' && _newFiles.isNotEmpty
              ? _newFiles
              : null,
        ),
        // _keepFileIds.toList(), // 유지할 기존 파일 ID 목록
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('필수 항목을 입력해주세요')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayOldFiles = _oldFiles
        .where((f) => _keepFileIds.contains(f.bfNo))
        .toList();

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
                    if (v == '외부공지사항' || v == '내부공지사항') {
                      _ca2Name = null;
                    }
                    _ca1Name = v;
                  }),
                ),
                SizedBox(height: 12.h),
              ],
              if (widget.ca2Names.contains('공통') ||
                  widget.ca2Names.isNotEmpty && _ca1Name != null) ...[
                Selector<String>(
                  hint: '유형2 선택',
                  items: _ca1Name != '외부공지사항'
                      ? widget.ca2Names
                            .where((e) => !['공고문', '언론보도'].contains(e))
                            .toList()
                      : widget.ca2Names
                            .where((e) => ['공고문', '언론보도'].contains(e))
                            .toList(),
                  selected: _ca2Name,
                  getLabel: (v) => v,
                  onSelected: (v) => setState(() {
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
              // 기간
              if (widget.isEduEvent) ...[
                AppTextField(
                  hint: '0000.00.00 ~ 0000.00.00',
                  controller: _wr4,
                  textInputAction: TextInputAction.next,
                  dimOnLocked: false,
                ),
                SizedBox(height: 12.h),
              ],

              // 내용
              HtmlEditor(
                controller: _htmlController,
                htmlEditorOptions: HtmlEditorOptions(
                  initialText: widget.post?.wrContent ?? '',
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarType: ToolbarType.nativeScrollable,
                  defaultToolbarButtons: [
                    FontButtons(
                      // 굵게, 기울임, 밑줄 등
                      bold: true,
                      italic: true,
                      underline: true,
                      clearAll: false,
                      strikethrough: false,
                      subscript: false,
                      superscript: false,
                    ),

                    ListButtons(ul: true, ol: true, listStyles: false),
                    InsertButtons(
                      link: true,
                      picture: true,
                      audio: false,
                      video: false,
                      table: false,
                      hr: false,
                    ),
                  ],
                  mediaUploadInterceptor: (file, type) async {
                    type == InsertFileType.image;
                    if (type != InsertFileType.image) return false;
                    try {
                      // bytes 가져오기 (모바일에서는 path로 읽어야 하는 경우도 있으니 둘 다 대응)
                      Uint8List bytes;
                      if (file.bytes != null) {
                        bytes = file.bytes!;
                      } else if (file.path != null) {
                        bytes = await File(file.path!).readAsBytes();
                      } else {
                        debugPrint(
                          '[editor] mediaUploadInterceptor: no bytes/path',
                        );
                        return true; // 기본 동작(=base64 삽입)으로 fallback
                      }

                      final filename = file.name;
                      // 서버 업로드
                      final imageUrl = await ref
                          .read(fileRepositoryProvider)
                          .uploadEditorImageFromBytes(
                            bytes: bytes,
                            filename: filename,
                          );

                      if (imageUrl != null) {
                        // 에디터에 네트워크 이미지 삽입
                        final html =
                            '<img src="$imageUrl" filename = "$filename" alt="$filename">';
                        // 1) 에디터에 포커스
                        _htmlController.setFocus();

                        // 2) selection이 정리된 뒤에 HTML 삽입
                        Future.microtask(() async {
                          _htmlController.insertHtml(html);
                        });
                        return false;
                      } else {
                        // 업로드 실패 시에는 에디터라도 보여주고 싶으면 true로 리턴
                        return true;
                      }
                    } catch (e) {
                      // 에러 시 기본 동작 유지
                      return false;
                    }
                  },
                ),
                otherOptions: const OtherOptions(height: 230),
              ),
              SizedBox(height: 12.h),

              // 비공개
              if (!widget.ca1Names.contains('공개') &&
                  !widget.ca2Names.contains('공통'))
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

              // 썸네일
              // 썸네일
              if (widget.isEduEvent) ...[
                Text('썸네일 이미지', style: AppTextStyles.psb16),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickThumbnail, // ★ 썸네일 선택
                  child: _thumbnailUrl != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                _thumbnailUrl!,
                                height: 140.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: _removeThumbnail, // ★ 썸네일 삭제
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 140.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.border),
                            color: AppColors.subtle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '썸네일 이미지를 선택하세요',
                            style: AppTextStyles.pr14,
                          ),
                        ),
                ),
                SizedBox(height: 8.h),
              ],

              AttachmentSection(
                oldFiles: displayOldFiles,
                newFiles: _newFiles,
                onAdd: _pickAndUploadFile,
                onRemoveOld: (bfNo) => _removeOldFile(bfNo),
                onRemoveNew: (savedName) => _removeNewFile(savedName),
                spacing: 8,
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
