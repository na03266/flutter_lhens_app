import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';

class SurveyDetailScreen extends StatefulWidget {
  static String get routeName => '설문 상세';

  const SurveyDetailScreen({super.key});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  // Mock meta
  SurveyStatus status = SurveyStatus.ongoing;
  SurveyNameType nameType = SurveyNameType.realname;
  bool participated = false;

  // Q1: Multiple choice (required) with '기타'
  final Set<int> _q1Selections = {}; // 0..n-1, with last index as 기타
  final _q1EtcController = TextEditingController();

  // Q2: Single choice (required)
  int? _q2Selection; // index

  // Q3: Subjective (optional)
  final _q3Controller = TextEditingController();

  @override
  void dispose() {
    _q1EtcController.dispose();
    _q3Controller.dispose();
    super.dispose();
  }

  bool get _q1EtcSelected => _q1Selections.contains(_q1Options.length - 1);

  final List<String> _q1Options = const ['항목 1', '항목 2', '기타'];
  final List<String> _q2Options = const ['항목 1', '항목 2'];

  void _toggleQ1(int index) {
    setState(() {
      if (_q1Selections.contains(index)) {
        _q1Selections.remove(index);
      } else {
        _q1Selections.add(index);
      }
    });
  }

  void _selectQ2(int index) {
    setState(() => _q2Selection = index);
  }

  void _onCancel() {
    Navigator.of(context).maybePop();
  }

  void _onSubmit() {
    // Validation: Q1 required, Q2 required; If 기타 selected in Q1, text required
    if (_q1Selections.isEmpty) {
      _showSnack('필수 문항을 선택해주세요 (객관식 - 중복선택)');
      return;
    }
    if (_q1EtcSelected && _q1EtcController.text.trim().isEmpty) {
      _showSnack('기타 내용을 입력해주세요');
      return;
    }
    if (_q2Selection == null) {
      _showSnack('필수 문항을 선택해주세요 (객관식)');
      return;
    }

    setState(() => participated = true);
    // 이동: 완료 화면
    if (mounted) {
      context.pushNamed('설문 완료');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.h),

              // Header (유사 스타일)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _statusChip(status),
                        SizedBox(width: 8.w),
                        _nameTypeChip(nameType),
                        const Spacer(),
                        _participationChip(participated),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '설문조사',
                      style: AppTextStyles.pm14.copyWith(color: AppColors.textSec),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '설문조사 제목 - 설문조사 제목이 표시되는 영역입니다.',
                      style: AppTextStyles.psb18.copyWith(
                        color: AppColors.text,
                        height: 1.35,
                        letterSpacing: -0.45,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // Meta info
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelValueLine.single(label1: '설문기간', value1: '2025. 01. 15 ~ 2025. 01. 16'),
                      LabelValueLine.single(label1: '설문대상', value1: '기획조정실 안전보건팀'),
                      LabelValueLine.single(label1: '작성자', value1: 'LH E&S'),
                      LabelValueLine.single(label1: '등록일', value1: '2025. 01. 05'),
                      LabelValueLine.single(label1: '조회수', value1: '278'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
                    child: Text(
                      '해당 설문조사는 업무속도개선을 위해 실시하고 있습니다. 참여 시 추첨을 통해 스타벅스 기프티콘 증정하고 있습니다. 많은 참여 바랍니다. 감사합니다.',
                      style: AppTextStyles.pr16.copyWith(color: AppColors.text, height: 1.5),
                    ),
                  ),
                ),
              ),

              // Questions
              SizedBox(height: 16.h),
              _sectionPadding(
                child: _questionBlock(
                  title: '* 객관식',
                  subtitle: '(중복선택)',
                  requiredMark: true,
                  child: Column(
                    children: [
                      for (int i = 0; i < _q1Options.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: i == _q1Options.length - 1 ? 0 : 8.h),
                          child: _optionTile(
                            label: _q1Options[i],
                            selected: _q1Selections.contains(i),
                            onTap: () => _toggleQ1(i),
                          ),
                        ),
                      if (_q1EtcSelected) ...[
                        SizedBox(height: 12.h),
                        _etcInput(_q1EtcController),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              _sectionPadding(
                child: _questionBlock(
                  title: '* 객관식',
                  requiredMark: true,
                  child: Column(
                    children: [
                      for (int i = 0; i < _q2Options.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: i == _q2Options.length - 1 ? 0 : 8.h),
                          child: _optionTile(
                            label: _q2Options[i],
                            selected: _q2Selection == i,
                            onTap: () => _selectQ2(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              _sectionPadding(
                child: _questionBlock(
                  title: '주관식 서술형',
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 82.h),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.subtle,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        controller: _q3Controller,
                        maxLines: null,
                        minLines: 3,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: '내용을 입력해주세요',
                        ),
                        style: AppTextStyles.pr16.copyWith(color: AppColors.text),
                      ),
                    ),
                  ),
                ),
              ),

              // Buttons
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: Row(
                  children: [
                    _textButton('취소', onTap: _onCancel),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _primaryButton('제출', onTap: _onSubmit),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  // UI Helpers
  Widget _statusChip(SurveyStatus status) {
    final ongoing = status == SurveyStatus.ongoing;
    final bg = ongoing ? const Color(0x191E3A8A) : AppColors.subtle;
    final border = ongoing ? const Color(0xFF1E3A8A) : AppColors.border;
    final textColor = ongoing ? const Color(0xFF1E3A8A) : AppColors.muted;
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: border),
      ),
      child: Center(
        child: Text(
          ongoing ? '진행중' : '마감',
          style: AppTextStyles.pb12.copyWith(color: textColor, height: 1.33),
        ),
      ),
    );
  }

  Widget _nameTypeChip(SurveyNameType nameType) {
    final isReal = nameType == SurveyNameType.realname;
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.textSec),
      ),
      child: Center(
        child: Text(
          isReal ? '실명' : '익명',
          style: AppTextStyles.pb12.copyWith(color: AppColors.muted, height: 1.33),
        ),
      ),
    );
  }

  Widget _participationChip(bool joined) {
    final bg = joined ? AppColors.primary : const Color(0xFF1E3A8A);
    final label = joined ? '참여' : '미참여';
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.pb12.copyWith(color: AppColors.white, height: 1.33),
        ),
      ),
    );
  }

  Widget _sectionPadding({required Widget child}) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFCFCFC),
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: AppColors.white,
        child: child,
      ),
    );
  }

  Widget _questionBlock({
    required String title,
    String? subtitle,
    bool requiredMark = false,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 4.h),
          child: Row(
            children: [
              if (requiredMark)
                Text('*', style: AppTextStyles.pr16.copyWith(color: const Color(0xFFE84866))),
              Text(title, style: AppTextStyles.pm16.copyWith(color: AppColors.text)),
              if (subtitle != null)
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(subtitle, style: AppTextStyles.pm16.copyWith(color: const Color(0xFFE84866))),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: child,
        ),
      ],
    );
  }

  Widget _optionTile({required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.subtle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: selected
                  ? Assets.icons.checkCircle.svg(width: 24.w, height: 24.w)
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.pm16.copyWith(color: AppColors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _etcInput(TextEditingController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Assets.icons.checkCircle.svg(width: 24.w, height: 24.w),
                  ),
                  SizedBox(width: 8.w),
                  Text('기타', style: AppTextStyles.pm16.copyWith(color: AppColors.text)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: '내용을 입력해주세요',
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                style: AppTextStyles.pr16.copyWith(color: AppColors.placeholder),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textButton(String text, {required VoidCallback onTap}) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.pb16.copyWith(color: AppColors.secondary),
          ),
        ),
      ),
    );
  }

  Widget _primaryButton(String text, {required VoidCallback onTap}) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(text, style: AppTextStyles.pb16.copyWith(color: AppColors.white)),
        ),
      ),
    );
  }
}
