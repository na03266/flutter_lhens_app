import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class ChatNameScreen extends ConsumerStatefulWidget {
  static String get routeName => '채팅방 정보';

  final String? initialName;
  final bool readOnly;

  const ChatNameScreen({super.key, this.initialName, this.readOnly = false});

  @override
  ConsumerState<ChatNameScreen> createState() => _ChatNameScreenState();
}

class _ChatNameScreenState extends ConsumerState<ChatNameScreen> {
  static const _maxLen = 30;

  final _name = TextEditingController();
  final _focus = FocusNode();
  String? _error;

  @override
  void initState() {
    super.initState();
    _name.text = widget.initialName ?? '';
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _trimmed => _name.text.trim();

  bool get _isCreate => widget.initialName == null;

  bool get _valid =>
      _trimmed.isNotEmpty && _trimmed.characters.length <= _maxLen;

  bool get _changed =>
      _isCreate ? _trimmed.isNotEmpty : _trimmed != (widget.initialName ?? '');

  bool get _canSubmit => !widget.readOnly && _valid && _changed;

  void _submit() {
    if (_trimmed.isEmpty) {
      setState(() => _error = '채팅방 이름을 입력하세요.');
      _focus.requestFocus();
      return;
    }
    if (_trimmed.characters.length > _maxLen) {
      setState(() => _error = '최대 $_maxLen자까지 가능합니다.');
      _focus.requestFocus();
      return;
    }
    if (!_changed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('변경된 내용이 없습니다.')));
      return;
    }
    context.pop<String>(_trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final count = _trimmed.characters.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, c) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w).add(
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: c.maxHeight,
                maxWidth: 420.w,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: '채팅방 이름',
                        hint: '채팅방 이름을 입력하세요',
                        controller: _name,
                        focusNode: _focus,
                        showClear: !widget.readOnly,
                        locked: widget.readOnly,
                        dimOnLocked: false,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        formatters: [LengthLimitingTextInputFormatter(_maxLen)],
                        onChanged: (_) {
                          if (_error != null && _valid) {
                            setState(() => _error = null);
                          }
                        },
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_error != null)
                            Text(
                              _error!,
                              style: TextStyle(
                                color: AppColors.danger,
                                fontSize: 12.sp,
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          Text(
                            '$count/$_maxLen',
                            style: TextStyle(
                              color: count > _maxLen
                                  ? AppColors.danger
                                  : AppColors.textTer,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      if (!widget.readOnly)
                        AppButton(
                          text: _isCreate ? '다음' : '저장',
                          onTap: _canSubmit ? _submit : null,
                          type: AppButtonType.secondary,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
