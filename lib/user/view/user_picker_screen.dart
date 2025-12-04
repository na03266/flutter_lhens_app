import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/search/search_bar.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/department/model/department_model.dart';
import 'package:lhens_app/department/provider/department_provider.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import 'package:lhens_app/mock/user_tree/mock_user_tree_models.dart';
import 'package:lhens_app/user/component/user_tree.dart';
import 'package:lhens_app/user/component/user_tree_v2.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

import 'package:lhens_app/mock/user_tree/mock_org_adapter.dart'
    show kMockDepartments;

class UserPickerScreen extends ConsumerStatefulWidget {
  static String get routeName => '알림 대상 선택';

  const UserPickerScreen({super.key});

  @override
  ConsumerState<UserPickerScreen> createState() => _UserPickerScreenState();
}

class _UserPickerScreenState extends ConsumerState<UserPickerScreen> {
  // 검색
  final _query = TextEditingController();
  String _appliedQuery = '';

  // 펼침/선택 상태
  final _expTeams = <int>{};
  final _selTeams = <int>{};
  final _selMbNo = <int>{};

  bool _scrolled = false;

  // 데이터

  // 선택 가능 여부
  bool get _canSubmit => _selTeams.isNotEmpty || _selMbNo.isNotEmpty;

  @override
  void initState() {
    super.initState();
    ref.read(departmentProvider.notifier);
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(departmentProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              // 검색바
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: _scrolled ? AppShadows.stickyBar : null,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                  child: SearchBar(
                    controller: _query,
                    hintText: '검색어를 입력하세요',
                    onSubmitted: (_) => setState(() {
                      _appliedQuery = _query.text.trim();
                    }),
                  ),
                ),
              ),
              SizedBox(height: 4.h),

              // 리스트
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is ScrollUpdateNotification) {
                      final atTop = n.metrics.pixels <= 0;
                      if (_scrolled == atTop) {
                        setState(() => _scrolled = !atTop);
                      }
                    }
                    return false;
                  },
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      if (state is! DepartmentModelList) ...[
                        SizedBox(height: 40.h),
                        EmptyState(
                          iconPath: Assets.icons.user.path,
                          message: '선택할 직원이 없습니다.',
                        ),
                        SizedBox(height: 48.h),
                      ] else if (state.data.isEmpty) ...[
                        SizedBox(height: 40.h),
                        EmptyState(
                          iconPath: Assets.icons.search.path,
                          message: '검색어와 일치하는 대상이 없습니다.',
                        ),
                        SizedBox(height: 48.h),
                      ] else ...[
                        UserTreeV2(
                          departmentList: state.data,
                          onTeamExpanded: (state, id) async {
                            // 확장시 선택 조건
                            await ref
                                .read(departmentProvider.notifier)
                                .getDetail(id);
                            setState(() {
                              if (state) {
                                _expTeams.add(id);
                              } else {
                                _expTeams.remove(id);
                              }
                            });
                          },
                          onTeamSelected: (state, id) {
                            // 팀 선택시 활성
                            setState(() {
                              if (state) {
                                _selTeams.add(id);
                              } else {
                                _selTeams.remove(id);
                              }
                            });
                          },
                          onMbSelected: (state, id) {
                            // 멤버 선택시 설정
                            setState(() {
                              if (state) {
                                _selMbNo.add(id);
                              } else {
                                _selMbNo.remove(id);
                              }
                            });
                          },
                          expandedTeam: _expTeams,
                          selectedTeam: _selTeams,
                          selectedMb: _selMbNo,
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // 완료 버튼
                      AppButton(
                        text: '선택완료',
                        type: AppButtonType.secondary,
                        onTap: _canSubmit
                            ? () {
                                context.pop<UserPickResult>(
                                  UserPickResult(
                                    departments: _selTeams.toList(),
                                    members: _selMbNo.toList(),
                                  ),
                                );
                              }
                            : null,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
