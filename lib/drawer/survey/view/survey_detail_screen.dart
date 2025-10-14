import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/drawer/survey/component/survey_detail_header.dart';
import 'package:lhens_app/drawer/survey/component/survey_detail_body.dart';
import 'package:lhens_app/drawer/survey/component/survey_question.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';

class SurveyDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '설문 상세';

  const SurveyDetailScreen({super.key});

  @override
  ConsumerState<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends ConsumerState<SurveyDetailScreen> {
  // mock 데이터 옵션
  static const _mockQ1 = ['항목 1', '항목 2', '항목 3'];
  static const _mockQ2 = ['항목 1', '항목 2', '기타'];
  static const _msgReq = '필수 문항을 확인해주세요.';

  // 로컬 상태
  double _scale = 1.0;
  final Set<int> _selQ1 = {};
  int? _selQ2;

  final _q2EtcCon = TextEditingController();
  final _q3Con = TextEditingController();

  // 주관식 임시 플래그
  final bool _q3Required = false;

  @override
  void dispose() {
    _q2EtcCon.dispose();
    _q3Con.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  // 유효성
  String? _validateChoice({
    required bool isRequired,
    required bool isMulti,
    required List<String> options,
    Set<int>? selIdxs,
    int? selIdx,
    bool enableEtc = false,
    TextEditingController? etcCon,
  }) {
    final hasAnswer = isMulti
        ? (selIdxs?.isNotEmpty ?? false)
        : (selIdx != null);
    if (isRequired && !hasAnswer) return _msgReq;

    if (enableEtc && options.isNotEmpty) {
      final etcIdx = options.length - 1;
      final etcOn = isMulti
          ? (selIdxs?.contains(etcIdx) ?? false)
          : selIdx == etcIdx;
      if (etcOn && (etcCon?.text.trim().isEmpty ?? true)) {
        return '기타 내용을 입력해주세요';
      }
    }
    return null;
  }

  bool _validateSubmit() {
    final err1 = _validateChoice(
      isRequired: true,
      isMulti: true,
      options: _mockQ1,
      selIdxs: _selQ1,
    );

    final err2 = _validateChoice(
      isRequired: true,
      isMulti: false,
      options: _mockQ2,
      selIdx: _selQ2,
      enableEtc: true,
      etcCon: _q2EtcCon,
    );

    final err3 = (_q3Required && _q3Con.text.trim().isEmpty) ? _msgReq : null;

    final firstError = err1 ?? err2 ?? err3;
    if (firstError != null) {
      _showMsg(firstError);
      return false;
    }
    return true;
  }

  void _onCancel() => Navigator.of(context).maybePop();

  void _onSubmit() {
    if (!_validateSubmit()) return;
    context.pushNamed('설문 완료');
  }

  @override
  Widget build(BuildContext context) {
    // 헤더 메타(mock 데이터)
    final status = SurveyStatus.ongoing;
    final nameType = SurveyNameType.realname;
    final participated = false;

    final hpad = 16.w;

    final metaRows = _gapList(const [
      LabelValueLine.single(
        label1: '설문기간',
        value1: '2025. 01. 15 ~ 2025. 01. 16',
      ),
      LabelValueLine.single(label1: '설문대상', value1: '기획조정실 안전보건팀'),
      LabelValueLine.single(label1: '작성자', value1: 'LH E&S'),
      LabelValueLine.single(label1: '등록일', value1: '2025. 01. 05'),
      LabelValueLine.single(label1: '조회수', value1: '278'),
    ], 5.h);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24.h),

                  // 헤더
                  SurveyDetailHeader(
                    status: status,
                    nameType: nameType,
                    participated: participated,
                    title: '설문조사 제목이 표시되는 영역입니다. 설문조사 제목이 표시되는 영역입니다.',
                  ),

                  // 바디(글자크기+메타+소개+구분선)
                  SurveyDetailBody(
                    textScale: _scale,
                    onTextScaleChanged: (v) => setState(() => _scale = v),
                    metaRows: metaRows,
                    introText:
                        '해당 설문조사는 업무속도개선을 위해 실시하고 있습니다. 참여 시 추첨을 통해 스타벅스 기프티콘 증정하고 있습니다. 많은 참여 바랍니다. 감사합니다.',
                  ),

                  SizedBox(height: 14.h),

                  // 필수 안내
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hpad),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '* 필수 문항',
                        style: AppTextStyles.pm14.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ),

                  // 객관식(중복선택)
                  SurveyQuestion(
                    type: SurveyQuestionType.multi,
                    title: '객관식',
                    isRequired: true,
                    options: _mockQ1,
                    selectedIndexes: _selQ1,
                    onMultiChanged: (sel, _) => setState(() {
                      _selQ1
                        ..clear()
                        ..addAll(sel);
                    }),
                  ),

                  // 객관식(단일) + 기타(마지막 옵션)
                  SurveyQuestion(
                    type: SurveyQuestionType.single,
                    title: '객관식',
                    isRequired: true,
                    enableEtc: true,
                    options: _mockQ2,
                    selectedIndex: _selQ2,
                    etcController: _q2EtcCon,
                    onSingleChanged: (i) => setState(() => _selQ2 = i),
                  ),

                  // 주관식
                  SurveyQuestion(
                    type: SurveyQuestionType.text,
                    title: '주관식 서술형',
                    isRequired: _q3Required,
                    textController: _q3Con,
                  ),

                  // 제출 버튼
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hpad),
                    child: Row(
                      children: [
                        AppButton(
                          text: '취소',
                          type: AppButtonType.plain,
                          width: 100.w,
                          onTap: _onCancel,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: AppButton(
                            text: '제출',
                            type: AppButtonType.secondary,
                            onTap: _onSubmit,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 간격
  List<Widget> _gapList(List<Widget> items, double gap) {
    if (items.isEmpty) return items;
    return [
      for (int i = 0; i < items.length; i++) ...[
        items[i],
        if (i != items.length - 1) SizedBox(height: gap),
      ],
    ];
  }
}
