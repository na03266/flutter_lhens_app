import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/link_text.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/utils/tel_formatter.dart';

class ChangeInfoScreen extends ConsumerStatefulWidget {
  static String get routeName => '정보변경';

  const ChangeInfoScreen({super.key});

  @override
  ConsumerState<ChangeInfoScreen> createState() => _ChangeInfoScreenState();
}

class _ChangeInfoScreenState extends ConsumerState<ChangeInfoScreen> {
  // 초기값(서버에서 내려온 값이라 가정)
  final _initOffice = '055-000-0000';
  final _initMobile = '010-0000-0000';
  final _initEmail = 'lh@test.com';

  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final officePhone = TextEditingController();
  final mobilePhone = TextEditingController();
  final email = TextEditingController();

  final _pwFocus = FocusNode();
  final _pw2Focus = FocusNode();

  String? _pwError; // 비번 불일치 인라인 에러

  @override
  void initState() {
    super.initState();
    officePhone.text = _initOffice;
    mobilePhone.text = _initMobile;
    email.text = _initEmail;
  }

  @override
  void dispose() {
    newPassword.dispose();
    confirmPassword.dispose();
    officePhone.dispose();
    mobilePhone.dispose();
    email.dispose();
    _pwFocus.dispose();
    _pw2Focus.dispose();
    super.dispose();
  }

  // 어떤 값이라도 바뀌었는지
  bool get _anyProfileChanged =>
      officePhone.text != _initOffice ||
      mobilePhone.text != _initMobile ||
      email.text != _initEmail ||
      newPassword.text.isNotEmpty ||
      confirmPassword.text.isNotEmpty;

  // 비번 입력 시에는 두 칸 모두 채움+일치 필요
  bool get _passwordValid {
    final a = newPassword.text;
    final b = confirmPassword.text;
    if (a.isEmpty && b.isEmpty) return true; // 비번 미변경
    if (a.isEmpty || b.isEmpty) return false; // 하나만 입력
    return a == b; // 둘 다 입력 시 일치
  }

  bool get _canSubmit => _anyProfileChanged && _passwordValid;

  void _syncPwErrorInline() {
    final a = newPassword.text;
    final b = confirmPassword.text;
    final next = (b.isEmpty) ? null : (a == b ? null : '새 비밀번호가 일치하지 않습니다.');
    if (next != _pwError) setState(() => _pwError = next);
  }

  void _submit() {
    // 최종 검증
    if (!_passwordValid) {
      setState(() => _pwError = '새 비밀번호가 일치하지 않습니다.');
      _pw2Focus.requestFocus();
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('정보가 저장되었습니다.')));
    if (context.canPop()) context.pop();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _confirmWithdraw() async {
    final result = await ConfirmDialog.show(
      context,
      title: '회원탈퇴',
      message: '회원을 탈퇴하시겠습니까?',
      destructive: true,
    );
    if (result == true) {
      // 탈퇴 처리 호출 위치
      _snack('탈퇴 요청이 접수되었습니다.');
    }
  }

  //   if (result == true) {
  //   print('회원탈퇴 확인');
  //   } else {
  //   print('회원탈퇴 취소');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, c) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w).add(
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
                      // 비밀번호 변경은 옵션
                      AppTextField(
                        label: '새 비밀번호',
                        controller: newPassword,
                        focusNode: _pwFocus,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          _syncPwErrorInline();
                          setState(() {}); // 버튼 갱신
                        },
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: '새 비밀번호 확인',
                        controller: confirmPassword,
                        focusNode: _pw2Focus,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        error: _pwError != null,
                        errorText: _pwError,
                        onSubmitted: (_) => _submit(),
                        onChanged: (_) {
                          _syncPwErrorInline();
                          setState(() {}); // 버튼 갱신
                        },
                      ),
                      SizedBox(height: 24.h),

                      AppTextField(
                        label: '사무전화',
                        controller: officePhone,
                        keyboard: TextInputType.phone,
                        formatters: [TelFormatter()],
                        showClear: true,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: 16.h),

                      AppTextField(
                        label: '휴대전화',
                        controller: mobilePhone,
                        keyboard: TextInputType.phone,
                        formatters: [TelFormatter()],
                        showClear: true,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: 16.h),

                      AppTextField(
                        label: '이메일',
                        controller: email,
                        keyboard: TextInputType.emailAddress,
                        showClear: true,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: 24.h),

                      AppButton(
                        text: '저장',
                        onTap: _canSubmit ? _submit : null,
                        type: AppButtonType.secondary,
                      ),
                      SizedBox(height: 12.h),

                      LinkText(
                        text: '회원탈퇴',
                        textAlign: TextAlign.right,
                        onTap: _confirmWithdraw,
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
