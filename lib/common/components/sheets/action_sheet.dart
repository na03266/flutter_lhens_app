import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';

class ActionItem {
  final String key;
  final String label;
  final bool destructive;

  ActionItem(this.key, this.label, {this.destructive = false});
}

Future<String?> showActionSheet(
  BuildContext context, {
  required List<ActionItem> actions,
  String cancelText = '취소',
}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _Sheet(actions: actions, cancelText: cancelText),
  );
}

class _Sheet extends StatelessWidget {
  final List<ActionItem> actions;
  final String cancelText;

  const _Sheet({required this.actions, required this.cancelText});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12.r);

    Widget _card(Widget child) => DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _card(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < actions.length; i++) ...[
                  if (i != 0) Divider(height: 1, color: AppColors.border),
                  PressScale(
                    onTap: () => Navigator.pop(context, actions[i].key),
                    child: Container(
                      height: 56.h,
                      alignment: Alignment.center,
                      child: Text(
                        actions[i].label,
                        style: actions[i].destructive
                            ? AppTextStyles.pr18.copyWith(
                                color: AppColors.danger,
                              )
                            : AppTextStyles.pr18,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 8.h),
          _card(
            PressScale(
              onTap: () => Navigator.pop(context, null),
              child: Container(
                height: 56.h,
                alignment: Alignment.center,
                child: Text(cancelText, style: AppTextStyles.pr18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
