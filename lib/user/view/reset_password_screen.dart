import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/custom_app_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  static String get routeName => 'reset-password';

  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final id = TextEditingController();
  final rrnTail = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final _idFocus = FocusNode();
  final _rrnFocus = FocusNode();
  final _newPwFocus = FocusNode();
  final _confirmPwFocus = FocusNode();

  String? _idError; // 사번 에러
  String? _rrnError; // 주민번호 에러
  String? _pwError; // 비밀번호 불일치 에러

  @override
  void dispose() {
    id.dispose();
    rrnTail.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    _idFocus.dispose();
    _rrnFocus.dispose();
    _newPwFocus.dispose();
    _confirmPwFocus.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      id.text.isNotEmpty &&
      rrnTail.text.isNotEmpty &&
      newPassword.text.isNotEmpty &&
      confirmPassword.text.isNotEmpty;

  void _validatePwMatchInline() {
    final a = newPassword.text;
    final b = confirmPassword.text;
    if (b.isEmpty) {
      if (_pwError != null) setState(() => _pwError = null);
      return;
    }
    if (a != b) {
      if (_pwError == null) setState(() => _pwError = '새 비밀번호가 일치하지 않습니다.');
    } else {
      if (_pwError != null) setState(() => _pwError = null);
    }
  }

  void _submit() {
    // 1. 사번 7자리 확인
    if (id.text.length != 7) {
      setState(() => _idError = '사번 7자리를 입력하세요.');
      _idFocus.requestFocus();
      return;
    } else {
      setState(() => _idError = null);
    }

    // 2. 주민등록번호 7자리 확인
    if (rrnTail.text.length != 7) {
      setState(() => _rrnError = '주민등록번호 뒷자리를 정확히 입력하세요.');
      _rrnFocus.requestFocus();
      return;
    } else {
      setState(() => _rrnError = null);
    }

    // 3. 새 비밀번호 필수
    if (newPassword.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('새 비밀번호를 입력하세요.')));
      _newPwFocus.requestFocus();
      return;
    }

    // 4. 비밀번호 일치 여부
    if (newPassword.text != confirmPassword.text) {
      setState(() => _pwError = '새 비밀번호가 일치하지 않습니다.');
      _confirmPwFocus.requestFocus();
      return;
    }

    // 성공
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('비밀번호가 재설정되었습니다.')));
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: '비밀번호 재설정',
        rightType: AppBarRightType.none,
      ),
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
                      // 사번
                      AppTextField(
                        label: '사번',
                        controller: id,
                        focusNode: _idFocus,
                        keyboard: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7),
                        ],
                        showClear: true,
                        error: _idError != null,
                        errorText: _idError,
                        onChanged: (_) {
                          if (_idError != null && id.text.length == 7) {
                            setState(() => _idError = null);
                          }
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 주민등록번호
                      AppTextField(
                        label: '주민등록번호 뒷자리',
                        controller: rrnTail,
                        focusNode: _rrnFocus,
                        keyboard: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7),
                        ],
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        error: _rrnError != null,
                        errorText: _rrnError,
                        onChanged: (_) {
                          if (_rrnError != null && rrnTail.text.length == 7) {
                            setState(() => _rrnError = null);
                          }
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 새 비밀번호
                      AppTextField(
                        label: '새 비밀번호',
                        controller: newPassword,
                        focusNode: _newPwFocus,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          _validatePwMatchInline();
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 16.h),

                      // 새 비밀번호 확인
                      AppTextField(
                        label: '새 비밀번호 확인',
                        controller: confirmPassword,
                        focusNode: _confirmPwFocus,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        error: _pwError != null,
                        errorText: _pwError,
                        onSubmitted: (_) => _submit(),
                        onChanged: (_) {
                          _validatePwMatchInline();
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 24.h),

                      // 저장 버튼
                      AppButton(
                        text: '저장',
                        onTap: _canSubmit ? _submit : null,
                        type: AppButtonType.primary,
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
