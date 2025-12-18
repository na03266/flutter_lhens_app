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
import 'package:lhens_app/department/model/department_detail_model.dart';
import 'package:lhens_app/department/provider/department_provider.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import 'package:lhens_app/user/component/user_tree_v2.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class UserPickerScreen extends ConsumerStatefulWidget {
  static String get routeName => '알림 대상 선택';

  const UserPickerScreen({super.key});

  @override
  ConsumerState<UserPickerScreen> createState() => _UserPickerScreenState();
}

class _UserPickerScreenState extends ConsumerState<UserPickerScreen> {
  // 검색
  final _query = TextEditingController();

  // 펼침/선택 상태
  final _expTeams = <int>{};
  final _selTeams = <int>{};
  final _selMbNo = <int>{};

  bool _scrolled = false;

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

  // 수정 검토 필요
  /// 하위 부서 ID
  List<int> _getAllChildDepartments(DepartmentModel root) {
    final result = <int>[];

    void dfs(DepartmentModel node) {
      for (final child in node.children) {
        result.add(child.id);
        dfs(child);
      }
    }

    dfs(root);
    return result;
  }

  List<int> _getAllMembers(DepartmentModel root) {
    final result = <int>[];

    void dfs(DepartmentModel node) {
      if (node is DepartmentDetailModel) {
        result.addAll(node.members.map((m) => m.mbNo));
      }
      for (final child in node.children) {
        dfs(child);
      }
    }

    dfs(root);
    return result;
  }

  /// ID 로 부서 검색
  DepartmentModel? _findDeptById(List<DepartmentModel> list, int id) {
    DepartmentModel? result;

    void dfs(DepartmentModel d) {
      if (d.id == id) {
        result = d;
        return;
      }
      for (final c in d.children) {
        dfs(c);
      }
    }

    for (final d in list) {
      dfs(d);
    }
    return result;
  }

  /// 부모찾기
  List<int> _findParentIds(List<DepartmentModel> list, int targetId) {
    final parents = <int>[];

    bool dfs(DepartmentModel node, List<int> stack) {
      if (node.id == targetId) {
        parents.addAll(stack);
        return true;
      }
      for (final c in node.children) {
        if (dfs(c, [...stack, node.id])) return true;
      }
      return false;
    }

    for (final root in list) {
      dfs(root, []);
    }
    return parents;
  }

  // 멤버를 포함하는 부서 ID 찾기
  int? _findDepartmentOwningMember(List<DepartmentModel> list, int memberId) {
    int? found;

    void dfs(DepartmentModel d) {
      if (found != null) return;

      if (d is DepartmentDetailModel) {
        if (d.members.any((m) => m.mbNo == memberId)) {
          found = d.id;
          return;
        }
      }
      for (final c in d.children) {
        dfs(c);
      }
    }

    for (final d in list) {
      dfs(d);
    }
    return found;
  }
  // 수정 끝

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
              // Container(
              //   decoration: BoxDecoration(
              //     color: AppColors.white,
              //     boxShadow: _scrolled ? AppShadows.stickyBar : null,
              //   ),
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
              //     child: SearchBar(
              //       controller: _query,
              //       hintText: '검색어를 입력하세요',
              //       onSubmitted: (_) {
              //
              //       },
              //     ),
              //   ),
              // ),
              SizedBox(height: 30.h),

              if(_query.text.isNotEmpty)
                Expanded(
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
                        // 수정 검토 필요
                        UserTreeV2(
                          departmentList: state.data,
                          expandedTeam: _expTeams,
                          selectedTeam: _selTeams,
                          selectedMb: _selMbNo,

                          // 부서 확장
                          onTeamExpanded: (expand, id) async {
                            if (expand) {
                              // 상세정보 호출
                              await ref
                                  .read(departmentProvider.notifier)
                                  .getDetail(id);

                              final rootList = state.data;
                              final dept = _findDeptById(rootList, id);

                              if (dept == null) {
                                setState(() {
                                  _expTeams.add(id);
                                });
                                return;
                              }

                              // 부모 중 이미 선택된 부서가 있는지 체크
                              final parents = _findParentIds(rootList, id);
                              final parentSelected =
                              parents.any((parentId) => _selTeams.contains(parentId));

                              final members = _getAllMembers(dept);

                              setState(() {
                                _expTeams.add(id);

                                // 부모가 선택된 상태라면 멤버도 선택
                                if (parentSelected) {
                                  _selMbNo.addAll(members);
                                }
                              });
                            } else {
                              setState(() {
                                _expTeams.remove(id);
                              });
                            }
                          },

                          // 부서 선택
                          onTeamSelected: (selected, id) async {
                            final rootList = state.data;

                            await ref.read(departmentProvider.notifier).getDetail(id);

                            final dept = _findDeptById(rootList, id);
                            if (dept == null) return;

                            final parents = _findParentIds(rootList, id);
                            setState(() {
                              _selTeams.removeAll(parents);
                            });

                            if (selected) {
                              final dept = _findDeptById(rootList, id);
                              if (dept == null) return;

                              final childs = _getAllChildDepartments(dept);
                              final members = _getAllMembers(dept);

                              setState(() {
                                _selTeams.add(id);
                                _selTeams.addAll(childs);
                                _selMbNo.addAll(members);
                              });
                            } else {
                              final childs = _getAllChildDepartments(dept);
                              final members = _getAllMembers(dept);

                              setState(() {
                                _selTeams.remove(id);
                                _selTeams.removeAll(childs);

                                _selMbNo.removeAll(members);
                              });
                            }
                          },

                          // 멤버 선택
                          onMbSelected: (selected, mbNo) {
                            final rootList = state.data;

                            // 멤버를 포함한 부서 찾기
                            final deptId = _findDepartmentOwningMember(rootList, mbNo);
                            if (deptId == null) return;

                            // 상위 부서 id
                            final parents = _findParentIds(rootList, deptId);

                            setState(() {
                              // -> 멤버 단위 계산
                              _selTeams.remove(deptId);
                              _selTeams.removeAll(parents);

                              // 멤버 선택/해제 반영
                              if (selected) {
                                _selMbNo.add(mbNo);
                              } else {
                                _selMbNo.remove(mbNo);
                              }

                              // 선택 확인
                              bool _syncDeptSelection(int id) {
                                final dept = _findDeptById(rootList, id);
                                if (dept == null) return false;

                                final allMembers = _getAllMembers(dept);
                                if (allMembers.isEmpty) return false;

                                final allSelected = allMembers.every((m) => _selMbNo.contains(m));
                                if (allSelected) {
                                  _selTeams.add(id);
                                } else {
                                  _selTeams.remove(id);
                                }
                                return allSelected;
                              }

                              _syncDeptSelection(deptId);

                              for (final p in parents.reversed) {
                                _syncDeptSelection(p);
                              }
                            });
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                      // 수정 끝

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
                )
                else
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
                        // 수정 검토 필요
                        UserTreeV2(
                          departmentList: state.data,
                          expandedTeam: _expTeams,
                          selectedTeam: _selTeams,
                          selectedMb: _selMbNo,

                          // 부서 확장
                          onTeamExpanded: (expand, id) async {
                            if (expand) {
                              // 상세정보 호출
                              await ref
                                  .read(departmentProvider.notifier)
                                  .getDetail(id);

                              final rootList = state.data;
                              final dept = _findDeptById(rootList, id);

                              if (dept == null) {
                                setState(() {
                                  _expTeams.add(id);
                                });
                                return;
                              }

                              // 부모 중 이미 선택된 부서가 있는지 체크
                              final parents = _findParentIds(rootList, id);
                              final parentSelected =
                              parents.any((parentId) => _selTeams.contains(parentId));

                              final members = _getAllMembers(dept);

                              setState(() {
                                _expTeams.add(id);

                                // 부모가 선택된 상태라면 멤버도 선택
                                if (parentSelected) {
                                  _selMbNo.addAll(members);
                                }
                              });
                            } else {
                              setState(() {
                                _expTeams.remove(id);
                              });
                            }
                          },

                          // 부서 선택
                          onTeamSelected: (selected, id) async {
                            final rootList = state.data;

                            await ref.read(departmentProvider.notifier).getDetail(id);

                            final dept = _findDeptById(rootList, id);
                            if (dept == null) return;

                            final parents = _findParentIds(rootList, id);
                            setState(() {
                              _selTeams.removeAll(parents);
                            });

                            if (selected) {
                              final dept = _findDeptById(rootList, id);
                              if (dept == null) return;

                              final childs = _getAllChildDepartments(dept);
                              final members = _getAllMembers(dept);

                              setState(() {
                                _selTeams.add(id);
                                _selTeams.addAll(childs);
                                _selMbNo.addAll(members);
                              });
                            } else {
                              final childs = _getAllChildDepartments(dept);
                              final members = _getAllMembers(dept);

                              setState(() {
                                _selTeams.remove(id);
                                _selTeams.removeAll(childs);

                                _selMbNo.removeAll(members);
                              });
                            }
                          },

                          // 멤버 선택
                          onMbSelected: (selected, mbNo) {
                            final rootList = state.data;

                            // 멤버를 포함한 부서 찾기
                            final deptId = _findDepartmentOwningMember(rootList, mbNo);
                            if (deptId == null) return;

                            // 상위 부서 id
                            final parents = _findParentIds(rootList, deptId);

                            setState(() {
                              // -> 멤버 단위 계산
                              _selTeams.remove(deptId);
                              _selTeams.removeAll(parents);

                              // 멤버 선택/해제 반영
                              if (selected) {
                                _selMbNo.add(mbNo);
                              } else {
                                _selMbNo.remove(mbNo);
                              }

                              // 선택 확인
                              bool _syncDeptSelection(int id) {
                                final dept = _findDeptById(rootList, id);
                                if (dept == null) return false;

                                final allMembers = _getAllMembers(dept);
                                if (allMembers.isEmpty) return false;

                                final allSelected = allMembers.every((m) => _selMbNo.contains(m));
                                if (allSelected) {
                                  _selTeams.add(id);
                                } else {
                                  _selTeams.remove(id);
                                }
                                return allSelected;
                              }

                              _syncDeptSelection(deptId);

                              for (final p in parents.reversed) {
                                _syncDeptSelection(p);
                              }
                            });
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                      // 수정 끝

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
