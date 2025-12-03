import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/drawer/salary/provider/salary_provider.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class SalaryAuthScreen extends ConsumerStatefulWidget {
  static String get routeName => 'salary-auth';
  final String id;

  const SalaryAuthScreen({super.key, required this.id});

  @override
  ConsumerState<SalaryAuthScreen> createState() => _SalaryAuthScreenState();
}

class _SalaryAuthScreenState extends ConsumerState<SalaryAuthScreen> {
  final TextEditingController _rrnTail = TextEditingController();
  String? _filePath;

  @override
  void dispose() {
    _rrnTail.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final value = _rrnTail.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('주민등록번호 뒷자리를 입력해주세요.')));
      return;
    }
    final user = ref.read(userMeProvider) as UserModel;
    if (value == user.registerNum) {
      await _prepareHtmlFile();
      await _openExternal();
    }
  }

  Future<void> _prepareHtmlFile() async {
    // 1. 서버에서 HTML 문자열 가져오기
    final html = await ref
        .read(salaryProvider.notifier)
        .getSalary(id: int.parse(widget.id));

    // 2. 임시 디렉터리 경로
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/salary_${widget.id}.html';

    // 3. 파일로 저장 (UTF-8)
    final file = File(path);
    await file.writeAsString(html, encoding: utf8);

    if (!mounted) return;

    setState(() {
      _filePath = path;
    });
  }

  Future<void> _openExternal() async {
    if (_filePath == null) return;

    final result = await OpenFilex.open(_filePath!, type: 'text/html');

    debugPrint('OpenFilex result: ${result.type}  message: ${result.message}');
    // 필요하면 result 보고 에러 스낵바 처리
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF197487), Color(0xFF30AA88), Color(0xFF79BD38)],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.illustrations.salaryCharacter.image(
                  width: 140.w,
                  height: 140.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 32.h),

                Text('주민등록번호 뒷자리를 입력해주세요', style: AppTextStyles.psb18),
                SizedBox(height: 32.h),

                AppTextField(
                  hint: '주민등록번호 뒷자리',
                  keyboard: TextInputType.number,
                  textAlign: TextAlign.center,
                  isPassword: true,
                  formatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(7),
                  ],
                  controller: _rrnTail,
                  onSubmitted: (_) => _onSubmit(),
                ),
                SizedBox(height: 28.h),

                AppButton(
                  text: '다음',
                  type: AppButtonType.secondary,
                  onTap: _onSubmit,
                  height: 56.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
