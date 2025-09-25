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

  @override
  void dispose() {
    id.dispose();
    rrnTail.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void _submit() {
    if (newPassword.text != confirmPassword.text) {
      _snack('새 비밀번호가 일치하지 않습니다.');
      return;
    }
    _snack('비밀번호가 재설정되었습니다.');
    if (context.canPop()) context.pop();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

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
                      AppTextField(
                        label: '사번',
                        controller: id,
                        keyboard: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        showClear: true,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        label: '주민등록번호 뒷자리',
                        controller: rrnTail,
                        keyboard: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7),
                        ],
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16.h),
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
                      AppButton(
                        text: '저장',
                        onTap: _submit,
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
