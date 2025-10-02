import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/search/search_bar.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/mock/user_tree/mock_user_tree_data.dart';
import 'package:lhens_app/mock/user_tree/mock_user_tree_models.dart';
import 'package:lhens_app/user/component/user_tree.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';


/// 알림 대상 선택
class UserPickerScreen extends StatefulWidget {
  static String get routeName => '알림 대상 선택';
  const UserPickerScreen({super.key});

  @override
  State<UserPickerScreen> createState() => _UserPickerScreenState();
}

class _UserPickerScreenState extends State<UserPickerScreen> {
  final _query = TextEditingController();

  // 펼침/선택 상태
  final _expandedDepts = <String>{'기획조정실'};
  final _expandedTeams = <String>{'기획조정실/경영기획팀'};

  // 선택(멤버는 id로 관리)
  final _selDepts = <String>{};
  final _selTeams = <String>{}; // "부서/팀"
  final _selectedMemberIds = <String>{};

  bool _scrolled = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  // ===== Mock 데이터 =====
  List<Department> get _data => kMockDepartments;

  // ===== Helper (탐색) =====
  Department? _findDept(String deptName) {
    for (final d in _data) {
      if (d.name == deptName) return d;
    }
    return null;
  }

  Team? _findTeam(String deptName, String teamName) {
    final d = _findDept(deptName);
    if (d == null) return null;
    for (final t in d.teams) {
      if (t.name == teamName) return t;
    }
    return null;
  }

  Iterable<Employee> _employeesInDept(String deptName) sync* {
    final d = _findDept(deptName);
    if (d == null) return;
    for (final t in d.teams) {
      yield* t.members;
    }
  }

  Iterable<Employee> _employeesInTeam(String deptName, String teamName) sync* {
    final t = _findTeam(deptName, teamName);
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

  bool _areAllTeamMembersSelected(String deptName, String teamName) {
    for (final m in _employeesInTeam(deptName, teamName)) {
      if (!_selectedMemberIds.contains(m.id)) return false;
    }
    return true;
  }

  bool _areAllDeptMembersSelected(String deptName) {
    for (final m in _employeesInDept(deptName)) {
      if (!_selectedMemberIds.contains(m.id)) return false;
    }
    return true;
  }

  // ===== Cascade 선택 동기화 =====
  void _applyDeptSelection(String deptName, bool selected) {
    final d = _findDept(deptName);
    if (d == null) return;

    if (selected) {
      _selDepts.add(deptName);
      for (final t in d.teams) {
        _selTeams.add('$deptName/${t.name}');
        for (final m in t.members) {
          _selectedMemberIds.add(m.id);
        }
      }
    } else {
      _selDepts.remove(deptName);
      for (final t in d.teams) {
        _selTeams.remove('$deptName/${t.name}');
        for (final m in t.members) {
          _selectedMemberIds.remove(m.id);
        }
      }
    }
  }

  void _applyTeamSelection(String deptName, String teamName, bool selected) {
    final key = '$deptName/$teamName';
    final teamMembers = _employeesInTeam(deptName, teamName);

    if (selected) {
      _selTeams.add(key);
      for (final m in teamMembers) {
        _selectedMemberIds.add(m.id);
      }
      if (_areAllDeptMembersSelected(deptName)) {
        _selDepts.add(deptName);
      }
    } else {
      _selTeams.remove(key);
      for (final m in teamMembers) {
        _selectedMemberIds.remove(m.id);
      }
      _selDepts.remove(deptName);
    }
  }

  void _syncParentsAfterMemberToggle(String memberId) {
    final path = _pathByMemberId(memberId);
    if (path == null) return;
    final deptName = path.dept.name;
    final teamName = path.team.name;

    // 팀 동기화
    if (_areAllTeamMembersSelected(deptName, teamName)) {
      _selTeams.add('$deptName/$teamName');
    } else {
      _selTeams.remove('$deptName/$teamName');
    }

    // 부서 동기화
    if (_areAllDeptMembersSelected(deptName)) {
      _selDepts.add(deptName);
    } else {
      _selDepts.remove(deptName);
    }
  }

  // ===== 검색 필터 =====
  List<Department> _filter(List<Department> source, String q) {
    if (q.isEmpty) return source;
    final lower = q.toLowerCase();

    return source
        .map((d) {
      final teams = d.teams
          .map((t) {
        final members = t.members
            .where((m) =>
        m.name.toLowerCase().contains(lower) ||
            m.id.toLowerCase().contains(lower) ||
            m.position.toLowerCase().contains(lower))
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
    final list = _filter(_data, _query.text.trim());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 검색바
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: _scrolled
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                child: SearchBar(
                  controller: _query,
                  hintText: '검색어를 입력하세요',
                  onSubmitted: (_) => setState(() {}),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // 트리
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollUpdateNotification) {
                    final atTop = n.metrics.pixels <= 0;
                    if (_scrolled == atTop) setState(() => _scrolled = !atTop);
                  }
                  return false;
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    UserTree<Department, Team, Employee>(
                      data: list,

                      // 부서
                      deptName: (d) => d.name,
                      teamsOf: (d) => d.teams,
                      isDeptExpanded: (d) => _expandedDepts.contains(d.name),
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
                      isMemberSelected: (e) => _selectedMemberIds.contains(e.id),
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
                    SizedBox(height: 32.h),

                    AppButton(
                      text: '선택완료',
                      type: AppButtonType.secondary,
                      onTap: () {
                        final memberLabels = _selectedMemberIds
                            .map(_employeeById)
                            .whereType<Employee>()
                            .map((e) => e.label)
                            .toList();
                        final deptNames = _selDepts.toList();
                        context.pop<UserPickResult>(
                          UserPickResult(departments: deptNames, members: memberLabels),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}