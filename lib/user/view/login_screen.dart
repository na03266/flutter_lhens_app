import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/inputs/app_text_field.dart';
import 'package:lhens_app/common/components/link_text.dart';
import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/secure_storage/secure_storage.dart';
import 'package:lhens_app/user/model/user_model.dart';
import '../../common/components/dialogs/confirm_dialog.dart';
import '../../gen/assets.gen.dart';
import '../provider/user_me_provier.dart';
import 'reset_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final id = TextEditingController();
  final pw = TextEditingController();

  bool autoLogin = false;
  bool rememberId = true;

  @override
  void dispose() {
    id.dispose();
    pw.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadState());
  }

  loadState() async {
    final storage = ref.read(secureStorageProvider);
    final autoLoginState = await storage.read(key: AUTO_LOGIN);
    final savedId = await storage.read(key: SAVE_MB_NO);
    setState(() {
      autoLoginState == null ? autoLogin = false : autoLogin = true;
      if (savedId == null) {
        rememberId = false;
      } else {
        rememberId = true;
        id.text = savedId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w).add(
                  EdgeInsets.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: 420.w,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 로고
                        Assets.logos.logoPrimary.svg(width: 214.w),
                        SizedBox(height: 60.h),

                        // 사번 입력
                        AppTextField(
                          hint: '사번',
                          controller: id,
                          keyboard: TextInputType.number,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                            // TODO: 시번 글자 수에 맞춰 수정
                          ],
                          showClear: true,
                          height: 56.h,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 12.h),

                        // 비밀번호 입력
                        AppTextField(
                          hint: '비밀번호',
                          controller: pw,
                          isPassword: true,
                          height: 56.h,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleLogin(context, ref),
                        ),
                        SizedBox(height: 16.h),

                        // 비밀번호 재설정 링크
                        LinkText(
                          text: '비밀번호 재설정',
                          onTap: () {
                            context.pushNamed(ResetPasswordScreen.routeName);
                          },
                        ),
                        SizedBox(height: 16.h),

                        // 로그인 버튼
                        AppButton(
                          text: '로그인',
                          onTap: () => _handleLogin(context, ref),
                          type: AppButtonType.primary,
                        ),
                        SizedBox(height: 12.h),

                        // 자동 로그인 / 아이디 저장
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 24.w,
                          runSpacing: 8.h,
                          children: [
                            AppCheckbox(
                              label: '자동 로그인',
                              value: autoLogin,
                              onChanged: (v) => setState(() => autoLogin = v),
                            ),
                            AppCheckbox(
                              label: '아이디 저장',
                              value: rememberId,
                              onChanged: (v) => setState(() => rememberId = v),
                            ),
                          ],
                        ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    id.text = '0000001';
    pw.text = '9999';

    final username = id.text.trim();
    final password = pw.text;

    final storage = ref.read(secureStorageProvider);

    await storage.write(key: AUTO_LOGIN, value: autoLogin.toString());
    await storage.write(key: SAVE_MB_NO, value: id.text.trim());

    await ref
        .read(userMeProvider.notifier)
        .login(mbId: username, mbPassword: password);

    final state = ref.read(userMeProvider);

    if (state is UserModelError) {
      await ConfirmDialog.show(
        context,
        title: '로그인 실패',
        message: state.message,
        destructive: true,
      );
    }
  }
}
