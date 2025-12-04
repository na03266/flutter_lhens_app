import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/drawer/survey/component/survey_detail_body.dart';
import 'package:lhens_app/drawer/survey/component/survey_detail_header.dart';
import 'package:lhens_app/drawer/survey/component/survey_question.dart';
import 'package:lhens_app/drawer/survey/model/join_survey_dto.dart';
import 'package:lhens_app/drawer/survey/model/survey_detail_model.dart';
import 'package:lhens_app/drawer/survey/model/survey_question_model.dart';
import 'package:lhens_app/drawer/survey/provider/survey_provider.dart';
import 'package:lhens_app/drawer/survey/utils/survey_utils.dart';

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
  static const _msgReq = '필수 문항을 확인해주세요.';
  double _scale = 1.3;

  Set<JoinSurveyDto> selectedItems = {};

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

  bool _validateSubmit(SurveyDetailModel state) {
    // 모든 질문을 순회하면서, 필수(sqRequired == 1)인 것만 검사
    for (final q in state.questions) {
      if (q.sqRequired != 1) continue; // 선택 문항은 패스

      // 이 질문에 대한 모든 응답
      final answersForQ = selectedItems.where((a) => a.sqId == q.sqId).toList();

      // 1) 공통: 아무 응답도 없으면 바로 에러
      if (answersForQ.isEmpty) {
        _showMsg(_msgReq);
        return false;
      }

      // 2) 질문 타입별 추가 검사
      switch (q.sqType) {
        case SQType.text:
          // 주관식: text가 비어있지 않은 응답이 있는지
          final hasText = answersForQ.any(
            (a) => (a.text ?? '').trim().isNotEmpty,
          );
          if (!hasText) {
            _showMsg(_msgReq);
            return false;
          }
          break;

        case SQType.radio_text:
          // 라디오+기타:
          // - 일반 옵션만 선택된 경우 → OK
          // - soHasInput == 1(기타) 옵션이 선택된 경우 → text가 있어야 OK
          for (final ans in answersForQ) {
            // 현재 응답의 옵션 찾기
            var opt;
            for (final o in q.options) {
              if (o.soId == ans.soId) {
                opt = o;
                break;
              }
            }
            if (opt == null) continue;

            if (opt.soHasInput == 1) {
              // 기타 옵션이 선택된 경우 텍스트 필수
              if ((ans.text ?? '').trim().isEmpty) {
                _showMsg('기타 내용을 입력해주세요.');
                return false;
              }
            }
          }
          break;

        // 체크박스/일반 라디오는
        // "답 한 개 이상 있음"만 확인하면 충분하므로 추가 검사 없음
        case SQType.checkbox:
        case SQType.radio:
          break;
      }
    }

    // 모든 필수 문항 통과
    return true;
  }

  void _onCancel() => Navigator.of(context).maybePop();

  Future<void> _onSubmit() async {
    final state = ref.read(surveyDetailProvider(widget.poId));

    if (state is! SurveyDetailModel) {
      return;
    }

    if (!_validateSubmit(state)) return;

    // TODO: 여기서 selectedItems를 이용해 서버로 전송
    // 예:
    // final body = {
    //   'poId': int.parse(widget.poId),
    //   'answers': selectedItems.map((e) => e.toJson()).toList(),
    // };
    try {
      await ref
          .read(surveyProvider.notifier)
          .joinSurvey(poId: widget.poId, answers: selectedItems.toList());

      context.pushNamed('설문 완료');
    } on DioException catch (e) {
      // 서버에서 내려준 message 파싱
      final data = e.response?.data;
      String? serverMsg;
      if (data is Map<String, dynamic>) {
        final m = data['message'];
        if (m is String) {
          serverMsg = m;
        } else if (m is List && m.isNotEmpty) {
          serverMsg = m.first.toString();
        }
      }

      // "이미 참여한 설문입니다." 같이 서버 메시지가 있으면 그대로 보여주고,
      // 없으면 일반 에러 메시지
      _showMsg(serverMsg ?? '설문 제출 중 오류가 발생했습니다.');
    } catch (e) {
      _showMsg('설문 제출 중 알 수 없는 오류가 발생했습니다.');
    }
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
                          (q) => IgnorePointer(
                            ignoring: state.isSurvey || !getSurveyStatus(state),
                            child: SurveyQuestion(
                              model: q,
                              selectedItems: selectedItems,
                              onSelected: (checked, sqId, soId) {
                                final isRadio =
                                    q.sqType == SQType.radio ||
                                    q.sqType == SQType.radio_text;

                                setState(() {
                                  if (isRadio) {
                                    // 라디오는 같은 질문 ID의 기존 선택 모두 제거 후 새로 추가
                                    selectedItems.removeWhere(
                                      (e) => e.sqId == sqId,
                                    );
                                    if (checked) {
                                      selectedItems.add(
                                        JoinSurveyDto(sqId: sqId, soId: soId),
                                      );
                                    }
                                  } else {
                                    // 체크박스(복수선택)
                                    if (checked) {
                                      selectedItems.add(
                                        JoinSurveyDto(sqId: sqId, soId: soId),
                                      );
                                    } else {
                                      selectedItems.removeWhere(
                                        (e) => e.sqId == sqId && e.soId == soId,
                                      );
                                    }
                                  }
                                });
                              },
                              // 주관식 텍스트
                              onTextChanged: (sqId, answer) {
                                setState(() {
                                  // 동일 질문 ID + soId == null 인 이전 답변 제거
                                  selectedItems.removeWhere(
                                    (e) => e.sqId == sqId && e.soId == null,
                                  );

                                  if (answer.isEmpty) return;

                                  selectedItems.add(
                                    JoinSurveyDto(
                                      sqId: sqId,
                                      soId: null,
                                      text: answer,
                                    ),
                                  );
                                });
                              },

                              // 라디오 + 기타 텍스트
                              onEtcTextChanged: (sqId, soId, answer) {
                                setState(() {
                                  // 해당 질문/옵션의 기존 답변 제거
                                  selectedItems.removeWhere(
                                    (e) => e.sqId == sqId && e.soId == soId,
                                  );

                                  if (answer.isEmpty) return;

                                  selectedItems.add(
                                    JoinSurveyDto(
                                      sqId: sqId,
                                      soId: soId,
                                      text: answer,
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
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
                                onTap: state.isSurvey || !getSurveyStatus(state)
                                    ? null
                                    : _onSubmit, // participated면 버튼 비활성화
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
