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
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final officePhone = TextEditingController(text: '055-000-0000');
  final mobilePhone = TextEditingController(text: '010-0000-0000');
  final email = TextEditingController(text: 'lh@test.com');

  @override
  void dispose() {
    newPassword.dispose();
    confirmPassword.dispose();
    officePhone.dispose();
    mobilePhone.dispose();
    email.dispose();
    super.dispose();
  }

  void _submit() {
    if (newPassword.text != confirmPassword.text) {
      _snack('새 비밀번호가 일치하지 않습니다.');
      return;
    }
    _snack('정보가 저장되었습니다.');
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
      print('회원탈퇴 확인');
    } else {
      print('회원탈퇴 취소');
    }
  }

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
                      AppTextField(
                        label: '새 비밀번호',
                        controller: newPassword,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: '새 비밀번호 확인',
                        controller: confirmPassword,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                      ),
                      SizedBox(height: 24.h),
                      AppTextField(
                        label: '사무전화',
                        controller: officePhone,
                        keyboard: TextInputType.phone,
                        formatters: [TelFormatter()],
                        showClear: true,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: '휴대전화',
                        controller: mobilePhone,
                        keyboard: TextInputType.phone,
                        formatters: [TelFormatter()],
                        showClear: true,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: '이메일',
                        controller: email,
                        keyboard: TextInputType.emailAddress,
                        showClear: true,
                      ),
                      SizedBox(height: 24.h),
                      AppButton(
                        text: '저장',
                        onTap: _submit,
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
