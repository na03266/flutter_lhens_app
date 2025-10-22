import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset > 0 ? 0 : 0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.subtle, width: 1)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 첨부 버튼
              _SquareIconButton(
                size: 32.w,
                bg: AppColors.subtle,
                onTap: onAttach,
                child: Assets.icons.clip.svg(
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.text,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // 입력창
              Expanded(
                child: Container(
                  height: 40.h,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: '메세지를 입력하세요',
                      hintStyle: AppTextStyles.pm14.copyWith(
                        color: AppColors.placeholder,
                        height: 1.14,
                        letterSpacing: -0.35,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyles.pm14.copyWith(
                      color: AppColors.text,
                      height: 1.14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // 전송 버튼
              _SquareIconButton(
                size: 32.w,
                bg: AppColors.primarySoft,
                onTap: onSend,
                child: Assets.icons.send.svg(width: 18.w, height: 18.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? bg;
  final double size;

  const _SquareIconButton({
    required this.child,
    required this.onTap,
    this.bg,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg ?? AppColors.subtle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
