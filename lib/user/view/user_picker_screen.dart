import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/search/search_bar.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import 'package:lhens_app/mock/user_tree/mock_user_tree_models.dart';
import 'package:lhens_app/user/component/user_tree.dart';
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
  final _expandedDepts = <String>{};
  final _expandedTeams = <String>{};
  final _selDepts = <String>{};
  final _selTeams = <String>{};
  final _selectedMemberIds = <String>{};

  bool _scrolled = false;

  // 데이터
  List<Department> get _data => kMockDepartments;

  // 선택 가능 여부
  bool get _canSubmit =>
      _selectedMemberIds.isNotEmpty ||
      _selDepts.isNotEmpty ||
      _selTeams.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_data.isNotEmpty) _expandedDepts.add(_data.first.name);
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  // 헬퍼
  Department? _findDept(String name) {
    for (final d in _data) {
      if (d.name == name) return d;
    }
    return null;
  }

  Team? _findTeam(String dept, String team) {
    final d = _findDept(dept);
    if (d == null) return null;
    for (final t in d.teams) {
      if (t.name == team) return t;
    }
    return null;
  }

  Iterable<Employee> _employeesInDept(String dept) sync* {
    final d = _findDept(dept);
    if (d == null) return;
    for (final t in d.teams) yield* t.members;
  }

  Iterable<Employee> _employeesInTeam(String dept, String team) sync* {
    final t = _findTeam(dept, team);
    if (t == null) return;
    yield* t.members;
  }

  Employee? _employeeById(String id) {
    for (final d in _data) {
      for (final t in d.teams) {
        for (final m in t.members) {
          if (m.id == id) return m;
        }
      }
    }
    return null;
  }

  ({Department dept, Team team})? _pathByMemberId(String id) {
    for (final d in _data) {
      for (final t in d.teams) {
        for (final m in t.members) {
          if (m.id == id) return (dept: d, team: t);
        }
      }
    }
    return null;
  }

  bool _areAllTeamMembersSelected(String dept, String team) {
    for (final m in _employeesInTeam(dept, team)) {
      if (!_selectedMemberIds.contains(m.id)) return false;
    }
    return true;
  }

  bool _areAllDeptMembersSelected(String dept) {
    for (final m in _employeesInDept(dept)) {
      if (!_selectedMemberIds.contains(m.id)) return false;
    }
    return true;
  }

  void _applyDeptSelection(String dept, bool selected) {
    final d = _findDept(dept);
    if (d == null) return;

    if (selected) {
      _selDepts.add(dept);
      for (final t in d.teams) {
        _selTeams.add('$dept/${t.name}');
        for (final m in t.members) {
          _selectedMemberIds.add(m.id);
        }
      }
    } else {
      _selDepts.remove(dept);
      for (final t in d.teams) {
        _selTeams.remove('$dept/${t.name}');
        for (final m in t.members) {
          _selectedMemberIds.remove(m.id);
        }
      }
    }
  }

  void _applyTeamSelection(String dept, String team, bool selected) {
    final key = '$dept/$team';
    final members = _employeesInTeam(dept, team);

    if (selected) {
      _selTeams.add(key);
      for (final m in members) {
        _selectedMemberIds.add(m.id);
      }
      if (_areAllDeptMembersSelected(dept)) _selDepts.add(dept);
    } else {
      _selTeams.remove(key);
      for (final m in members) {
        _selectedMemberIds.remove(m.id);
      }
      _selDepts.remove(dept);
    }
  }

  void _syncParentsAfterMemberToggle(String memberId) {
    final path = _pathByMemberId(memberId);
    if (path == null) return;
    final dept = path.dept.name;
    final team = path.team.name;

    if (_areAllTeamMembersSelected(dept, team)) {
      _selTeams.add('$dept/$team');
    } else {
      _selTeams.remove('$dept/$team');
    }
    if (_areAllDeptMembersSelected(dept)) {
      _selDepts.add(dept);
    } else {
      _selDepts.remove(dept);
    }
  }

  // 검색 필터
  List<Department> _filter(List<Department> src, String q) {
    if (q.isEmpty) return src;
    final lower = q.toLowerCase();

    return src
        .map((d) {
          final teams = d.teams
              .map((t) {
                final members = t.members
                    .where(
                      (m) =>
                          m.name.toLowerCase().contains(lower) ||
                          m.id.toLowerCase().contains(lower) ||
                          m.position.toLowerCase().contains(lower),
                    )
                    .toList();
                if (members.isEmpty) return null;
                return Team(name: t.name, members: members);
              })
              .whereType<Team>()
              .toList();
          if (teams.isEmpty) return null;
          return Department(name: d.name, teams: teams);
        })
        .whereType<Department>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filter(_data, _appliedQuery);
    final noData = _data.isEmpty;
    final noResult = !noData && filtered.isEmpty;

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
                      if (noData) ...[
                        SizedBox(height: 40.h),
                        EmptyState(
                          iconPath: Assets.icons.user.path,
                          message: '선택할 직원이 없습니다.',
                        ),
                        SizedBox(height: 48.h),
                      ] else if (noResult) ...[
                        SizedBox(height: 40.h),
                        EmptyState(
                          iconPath: Assets.icons.search.path,
                          message: '검색어와 일치하는 대상이 없습니다.',
                        ),
                        SizedBox(height: 48.h),
                      ] else ...[
                        UserTree<Department, Team, Employee>(
                          data: filtered,
                          // 부서
                          deptName: (d) => d.name,
                          teamsOf: (d) => d.teams,
                          isDeptExpanded: (d) =>
                              _expandedDepts.contains(d.name),
                          onToggleDept: (d) => setState(() {
                            if (!_expandedDepts.add(d.name)) {
                              _expandedDepts.remove(d.name);
                            }
                          }),
                          isDeptSelected: (d) => _selDepts.contains(d.name),
                          onToggleDeptSelected: (d, v) => setState(() {
                            _applyDeptSelection(d.name, v);
                          }),
                          // 팀
                          teamName: (t) => t.name,
                          membersOf: (t) => t.members,
                          isTeamExpanded: (d, t) =>
                              _expandedTeams.contains('${d.name}/${t.name}') &&
                              _expandedDepts.contains(d.name),
                          onToggleTeam: (d, t) => setState(() {
                            final key = '${d.name}/${t.name}';
                            if (!_expandedTeams.add(key)) {
                              _expandedTeams.remove(key);
                            }
                          }),
                          isTeamSelected: (d, t) =>
                              _selTeams.contains('${d.name}/${t.name}'),
                          onToggleTeamSelected: (d, t, v) => setState(() {
                            _applyTeamSelection(d.name, t.name, v);
                          }),
                          // 멤버
                          isMemberSelected: (e) =>
                              _selectedMemberIds.contains(e.id),
                          onToggleMember: (e, selected) => setState(() {
                            if (selected) {
                              _selectedMemberIds.add(e.id);
                            } else {
                              _selectedMemberIds.remove(e.id);
                            }
                            _syncParentsAfterMemberToggle(e.id);
                          }),
                          memberTitle: (e) => e.name,
                          memberSubTitle: (e) => '${e.id} ${e.position}',
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // 완료 버튼
                      AppButton(
                        text: '선택완료',
                        type: AppButtonType.secondary,
                        onTap: _canSubmit
                            ? () {
                                final memberLabels = _selectedMemberIds
                                    .map(_employeeById)
                                    .whereType<Employee>()
                                    .map((e) => e.label)
                                    .toList();
                                final deptNames = _selDepts.toList();

                                context.pop<UserPickResult>(
                                  UserPickResult(
                                    departments: deptNames,
                                    members: memberLabels,
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
