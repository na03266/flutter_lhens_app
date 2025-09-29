import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';

class SalaryAuthScreen extends StatefulWidget {
  static String get routeName => 'salary-auth';

  const SalaryAuthScreen({super.key});

  @override
  State<SalaryAuthScreen> createState() => _SalaryAuthScreenState();
}

class _SalaryAuthScreenState extends State<SalaryAuthScreen> {
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final value = _password.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호를 입력해주세요.')),
      );
      return;
    }
    // TODO: 실제 인증 처리 로직 추가
    debugPrint('[AUTH] 주민번호 뒷자리 입력됨: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // salary.png 일러스트
            Assets.illustrations.salary.image(
              width: 120.w,
              height: 120.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 32.h),

            // 안내 문구
            Text(
              '비밀번호를 입력해주세요',
              style: AppTextStyles.pb16.copyWith(color: AppColors.text),
            ),
            SizedBox(height: 20.h),

            // 입력 필드
            AppTextField(
              hint: '주민등록번호 뒷자리',
              keyboard: TextInputType.number,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),

            // 버튼
            AppButton(
              text: '다음',
              type: AppButtonType.secondary,
              onTap: _onSubmit,
              height: 56.h,
            ),
          ],
        ),
      ),
    );
  }
}