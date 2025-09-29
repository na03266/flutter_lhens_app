import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool destructive; // 경고
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = '확인',
    this.cancelText = '취소',
    this.destructive = false,
    this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    bool destructive = false,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        destructive: destructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color confirmBg = destructive ? AppColors.danger : AppColors.primary;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.only(
          top: 38.h,
          left: 24.w,
          right: 24.w,
          bottom: 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.pb18.copyWith(),
            ),
            SizedBox(height: 24.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.pm16.copyWith(),
            ),
            SizedBox(height: 32.h),

            Row(
              children: [
                // 취소
                SizedBox(
                  width: 96.w,
                  height: 56.h,
                  child: PressScale(
                    onTap: () {
                      onCancel?.call();
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cancelText,
                        style: AppTextStyles.psb16.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),

                // 확인
                Expanded(
                  child: SizedBox(
                    height: 56.h,
                    child: PressScale(
                      onTap: () {
                        onConfirm?.call();
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: confirmBg,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          confirmText,
                          style: AppTextStyles.psb16.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
