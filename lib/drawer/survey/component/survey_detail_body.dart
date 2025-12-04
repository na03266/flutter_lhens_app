import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lhens_app/common/components/report/text_sizer.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyDetailBody extends StatelessWidget {
  final double textScale;
  final ValueChanged<double> onTextScaleChanged;
  final List<Widget> metaRows;
  final String introText;

  const SurveyDetailBody({
    super.key,
    required this.textScale,
    required this.onTextScaleChanged,
    required this.metaRows,
    required this.introText,
  });

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 글자 크기
        Padding(
          padding: EdgeInsets.fromLTRB(hpad, 8.h, hpad, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextSizer(value: textScale, onChanged: onTextScaleChanged),
          ),
        ),
        SizedBox(height: 12.h),

        // 메타
        _MetaSection(hpad: hpad, metaRows: metaRows),
        SizedBox(height: 16.h),

        // 소개 + 구분선
        _IntroWithDivider(hpad: hpad, text: introText, textScale: textScale),
      ],
    );
  }
}

// 메타
class _MetaSection extends StatelessWidget {
  const _MetaSection({required this.hpad, required this.metaRows});

  final double hpad;
  final List<Widget> metaRows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hpad),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: metaRows,
        ),
      ),
    );
  }
}

// 소개문 + 아래 구분선
class _IntroWithDivider extends StatelessWidget {
  const _IntroWithDivider({
    required this.hpad,
    required this.text,
    required this.textScale,
  });

  final double hpad;
  final String text;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    final sanitized = text
        .replaceAll('\r\n', '')
        .replaceAll('\n', '')
        .replaceAll('\r', '');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hpad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 4.h,
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // 전체 텍스트 스케일 조정 (1.0 = 기본, 1.2 = 20% 확대)
                textScaler: TextScaler.linear(textScale),
              ),
              child: Html(
                data: sanitized,
                onLinkTap: (url, _, __) {
                  if (url == null) return;
                  final uri = Uri.parse(url);
                  launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const Divider(color: AppColors.border, thickness: 1, height: 1),
        ],
      ),
    );
  }
}
