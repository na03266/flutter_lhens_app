import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

enum _Mode { single, double }

/// 한 줄에 라벨–값 한 쌍 또는 두 쌍을 그려주는 공용 위젯.
/// - 두 쌍 버전(.double): 기존 그리팅 카드 서식 그대로(라벨/값 모두 흰색, 간격 4/8).
/// - 한 쌍 버전(.single): 라벨 고정폭(기본 52), 색/서식 커스터마이즈 가능.
class LabelValueLine extends StatelessWidget {
  // ====== 공통 필드 ======
  final _Mode _mode;

  final String label1;
  final String value1;
  final String? label2;
  final String? value2;

  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  final EdgeInsetsGeometry? verticalPadding;

  /// 라벨–값 사이 간격
  final double? gapBetween;

  /// (double 전용) 첫 쌍과 두 번째 쌍 사이 간격
  final double? sideGap;

  /// (single 전용) 라벨 고정 너비
  final double? labelWidth;

  // ====== 생성자 ======
  /// 한 쌍(라벨/값)
  const LabelValueLine.single({
    super.key,
    required this.label1,
    required this.value1,
    this.labelWidth, // 기본 52.w
    this.labelStyle,
    this.valueStyle,
    this.verticalPadding,
    this.gapBetween, // 라벨–값 간격(기본 8)
  })  : _mode = _Mode.single,
        label2 = null,
        value2 = null,
        sideGap = null;

  /// 두 쌍(라벨/값 2세트)
  const LabelValueLine.double({
    super.key,
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
    this.labelStyle,
    this.valueStyle,
    this.verticalPadding,
    this.gapBetween, // 라벨–값 간격(기본 4)
    this.sideGap, // 첫 쌍과 두 번째 쌍 사이 간격(기본 8)
  })  : _mode = _Mode.double,
        labelWidth = null;

  // ====== 빌드 ======
  @override
  Widget build(BuildContext context) {
    switch (_mode) {
      case _Mode.single:
        return _buildSingle();
      case _Mode.double:
        return _buildDouble();
    }
  }

  // ====== private helper ======
  /// 한 쌍: 라벨 고정폭 + 값 확장
  Widget _buildSingle() {
    final _labelW = (labelWidth ?? 52).w;
    final _gap = (gapBetween ?? 8).w;
    final _vpad = verticalPadding ?? EdgeInsets.zero;

    final _labelStyle =
    (labelStyle ?? AppTextStyles.psb14.copyWith(color: AppColors.text));
    final _valueStyle =
    (valueStyle ?? AppTextStyles.pr14.copyWith(color: AppColors.text));

    return Padding(
      padding: _vpad,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _labelW,
            child: Text(label1, style: _labelStyle, maxLines: 1),
          ),
          SizedBox(width: _gap),
          Expanded(
            child: Text(
              value1,
              style: _valueStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 두 쌍: 기존 RichText 서식(라벨–값 4, 쌍 사이 8). 기본 흰색 유지.
  Widget _buildDouble() {
    final _gap = (gapBetween ?? 4).w;
    final _side = (sideGap ?? 8).w;
    final _vpad = verticalPadding ?? EdgeInsets.zero;

    final _labelStyle =
    (labelStyle ?? AppTextStyles.psb14.copyWith(color: AppColors.white));
    final _valueStyle =
    (valueStyle ?? AppTextStyles.pr14.copyWith(color: AppColors.white));

    return Padding(
      padding: _vpad,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: label1, style: _labelStyle),
            WidgetSpan(child: SizedBox(width: _gap)),
            TextSpan(text: value1, style: _valueStyle),
            if (label2 != null && value2 != null) ...[
              WidgetSpan(child: SizedBox(width: _side)),
              TextSpan(text: label2!, style: _labelStyle),
              WidgetSpan(child: SizedBox(width: _gap)),
              TextSpan(text: value2!, style: _valueStyle),
            ],
          ],
        ),
      ),
    );
  }
}