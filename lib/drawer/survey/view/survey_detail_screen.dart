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
import 'package:lhens_app/drawer/survey/model/join_survey_dto.dart';
import 'package:lhens_app/drawer/survey/model/survey_detail_model.dart';
import 'package:lhens_app/drawer/survey/provider/survey_provider.dart';
import 'package:lhens_app/drawer/survey/utils/survey_utils.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';

class SurveyDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '설문 상세';
  final String poId;

  const SurveyDetailScreen({super.key, required this.poId});

  @override
  ConsumerState<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends ConsumerState<SurveyDetailScreen> {
  int _pointerCount = 0; // 현재 화면을 누르고 있는 손가락 수
  bool _isMultiTouch = false; // 2개 이상일 때 true

  double _scale = 1.3;

  Set<JoinSurveyDto> selectedItems = {};

  final Set<int> _selQ1 = {};
  int? _selQ2;

  // 주관식 임시 플래그
  final bool _q3Required = false;

  @override
  void initState() {
    super.initState();
    ref.read(surveyProvider.notifier).getDetail(poId: widget.poId);
  }

  @override
  void dispose() {
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
    // if (isRequired && !hasAnswer) return _msgReq;

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
    // final err1 = _validateChoice(
    //   isRequired: true,
    //   isMulti: true,
    //   options: _mockQ1,
    //   selIdxs: _selQ1,
    // );
    //
    // final err2 = _validateChoice(
    //   isRequired: true,
    //   isMulti: false,
    //   options: _mockQ2,
    //   selIdx: _selQ2,
    //   enableEtc: true,
    //   etcCon: _q2EtcCon,
    // );
    //
    // final err3 = (_q3Required && _q3Con.text.trim().isEmpty) ? _msgReq : null;

    // final firstError = err1 ?? err2 ?? err3;
    // if (firstError != null) {
    //   _showMsg(firstError);
    //   return false;
    // }
    return true;
  }

  void _onCancel() => Navigator.of(context).maybePop();

  void _onSubmit() {
    if (!_validateSubmit()) return;
    context.pushNamed('설문 완료');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyDetailProvider(widget.poId));

    if (state == null || state is! SurveyDetailModel) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final hpad = 16.w;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Listener(
        onPointerDown: (_) {
          _pointerCount++;
          if (_pointerCount > 1 && !_isMultiTouch) {
            setState(() {
              _isMultiTouch = true; // 두 손가락 이상 눌리면 스크롤 비활성
            });
          }
        },
        onPointerUp: (_) {
          _pointerCount = (_pointerCount - 1).clamp(0, 10);
          if (_pointerCount <= 1 && _isMultiTouch) {
            setState(() {
              _isMultiTouch = false; // 한 손가락 이하가 되면 다시 스크롤 가능
            });
          }
        },
        onPointerCancel: (_) {
          _pointerCount = 0;
          if (_isMultiTouch) {
            setState(() {
              _isMultiTouch = false;
            });
          }
        },
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: SingleChildScrollView(
                physics: _isMultiTouch
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                child: InteractiveViewer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24.h),

                      // 헤더
                      SurveyDetailHeader(
                        isProcessing: getSurveyStatus(state),
                        participated: state.isSurvey,
                        title: state.poSubject,
                      ),

                      // 바디(글자크기+메타+소개+구분선)
                      SurveyDetailBody(
                        textScale: _scale,
                        onTextScaleChanged: (v) => setState(() => _scale = v),
                        metaRows: _gapList([
                          LabelValueLine.single(
                            label1: '설문기간',
                            value1: '${state.poDate} ~ ${state.poDateEnd}',
                          ),
                          LabelValueLine.single(
                            label1: '등록일',
                            value1: state.poDate,
                          ),
                          LabelValueLine.single(
                            label1: '참여자 수',
                            value1: state.poCount.toString(),
                          ),
                        ], 5.h),
                        introText: state.poContent,
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

                      if (state.questions.isNotEmpty)
                        ...state.questions.map(
                          (e) => SurveyQuestion(
                            model: e,
                            selectedItems: selectedItems,
                            onSelected: (state, sqId, soId){
                              setState(() {
                                if (state) {
                                  selectedItems.add(
                                      JoinSurveyDto(sqId: sqId, soId: soId));
                                } else {
                                  selectedItems.removeWhere(
                                        (e) => e.sqId == sqId && e.soId == soId,
                                  );
                                }
                              });

                            },
                          ),
                        ),
                      // // 객관식(중복선택)
                      // SurveyQuestion(
                      //   type: SurveyQuestionType.multi,
                      //   title: '객관식',
                      //   isRequired: true,
                      //   options: _mockQ1,
                      //   selectedIndexes: _selQ1,
                      //   onMultiChanged: (sel, _) =>
                      //       setState(() {
                      //         _selQ1
                      //           ..clear()
                      //           ..addAll(sel);
                      //       }),
                      // ),
                      //
                      //
                      // // 객관식(단일) + 기타(마지막 옵션)
                      // SurveyQuestion(
                      //   type: SurveyQuestionType.single,
                      //   title: '객관식',
                      //   isRequired: true,
                      //   enableEtc: true,
                      //   options: _mockQ2,
                      //   selectedIndex: _selQ2,
                      //   etcController: _q2EtcCon,
                      //   onSingleChanged: (i) => setState(() => _selQ2 = i),
                      // ),
                      //
                      // // 주관식
                      // SurveyQuestion(
                      //   type: SurveyQuestionType.text,
                      //   title: '주관식 서술형',
                      //   isRequired: _q3Required,
                      //   textController: _q3Con,
                      // ),

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
