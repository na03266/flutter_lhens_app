import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

enum _Mode { single, double }

class LabelValueLine extends StatelessWidget {
  final _Mode _mode;
  final String label1, value1;
  final String? label2, value2;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry? verticalPadding;
  final double? gapBetween;
  final double? sideGap;
  final double? labelWidth;

  const LabelValueLine.single({
    super.key,
    required this.label1,
    required this.value1,
    this.labelWidth,
    this.labelStyle,
    this.valueStyle,
    this.verticalPadding,
    this.gapBetween,
  }) : _mode = _Mode.single,
       label2 = null,
       value2 = null,
       sideGap = null;

  const LabelValueLine.double({
    super.key,
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
    this.labelStyle,
    this.valueStyle,
    this.verticalPadding,
    this.gapBetween,
    this.sideGap,
  }) : _mode = _Mode.double,
       labelWidth = null;

  @override
  Widget build(BuildContext context) {
    return switch (_mode) {
      _Mode.single => _buildSingle(),
      _Mode.double => _buildDouble(),
    };
  }

  // single: 라벨 고정폭 + 값 확장
  Widget _buildSingle() {
    final lw = (labelWidth ?? 62).w;
    final gap = (gapBetween ?? 4).w;
    final vpad = verticalPadding ?? EdgeInsets.zero;

    final ls =
        labelStyle ?? AppTextStyles.psb14.copyWith(color: AppColors.text);
    final vs = valueStyle ?? AppTextStyles.pr14.copyWith(color: AppColors.text);

    return Padding(
      padding: vpad,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: lw,
            child: Text(label1, style: ls, maxLines: 1),
          ),
          SizedBox(width: gap),
          Expanded(
            child: Text(
              value1,
              style: vs,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // double: 라벨–값 2쌍을 한 줄에 표시
  Widget _buildDouble() {
    final gap = (gapBetween ?? 4).w;
    final side = (sideGap ?? 8).w;
    final vpad = verticalPadding ?? EdgeInsets.zero;

    final ls =
        labelStyle ?? AppTextStyles.psb14.copyWith(color: AppColors.white);
    final vs =
        valueStyle ?? AppTextStyles.pr14.copyWith(color: AppColors.white);

    return Padding(
      padding: vpad,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: label1, style: ls),
            WidgetSpan(child: SizedBox(width: gap)),
            TextSpan(text: value1, style: vs),
            if (label2 != null && value2 != null) ...[
              WidgetSpan(child: SizedBox(width: side)),
              TextSpan(text: label2!, style: ls),
              WidgetSpan(child: SizedBox(width: gap)),
              TextSpan(text: value2!, style: vs),
            ],
          ],
        ),
      ),
    );
  }
}
