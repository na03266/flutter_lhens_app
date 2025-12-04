import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/department/model/department_detail_model.dart';
import 'package:lhens_app/department/model/department_model.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class UserTreeV2 extends StatefulWidget {
  final List<DepartmentModel> departmentList;
  final Function(bool, int) onTeamExpanded;
  final Function(bool, int) onTeamSelected;
  final Function(bool, int) onMbSelected;
  final Set<int> selectedTeam;
  final Set<int> expandedTeam;
  final Set<int> selectedMb;

  // 여백
  final double gapBetweenGroups;
  final double gapDeptTeam;
  final double gapTeamMember;

  const UserTreeV2({
    super.key,
    required this.departmentList,
    required this.onTeamExpanded,
    required this.onTeamSelected,
    required this.onMbSelected,
    this.gapBetweenGroups = 8,
    this.gapDeptTeam = 4,
    this.gapTeamMember = 0,
    required this.selectedTeam,
    required this.expandedTeam,
    required this.selectedMb,
  });

  @override
  State<UserTreeV2> createState() => _UserTreeV2State();
}

class _UserTreeV2State extends State<UserTreeV2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.departmentList.map((dept) {
        // 여기서 맘편하게 변수 뽑기
        final bool isDetail = dept is DepartmentDetailModel;
        final members = isDetail ? dept.members : const [];
        final children = dept.children;

        return Column(
          children: [
            _DeptTile(
              name: dept.name,
              expanded: widget.expandedTeam.contains(dept.id),
              selected: widget.selectedTeam.contains(dept.id),
              onExpanded: (state) => widget.onTeamExpanded(state, dept.id),
              onSelected: (state) => widget.onTeamSelected(state, dept.id),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1) 부서에 직접 속한 멤버들
                  ...members.map(
                    (m) => Padding(
                      padding: EdgeInsets.only(top: widget.gapDeptTeam.h),
                      child: _MemberRow(
                        name: m.mbName,
                        mbInfo: '${m.mbId} ${m.mb5}',
                        selected: widget.selectedMb.contains(m.mbNo),
                        onChanged: (state) =>
                            widget.onMbSelected(state, m.mbNo),
                      ),
                    ),
                  ),

                  if (members.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 26, right: 12),
                      child: Divider(
                        height: 14,
                        thickness: 1,
                        color: AppColors.subtle,
                      ),
                    ),

                  // 2) 하위 사업소/팀
                  ...children.map((dept2) {
                    final teamExpanded = widget.expandedTeam.contains(dept2.id);
                    final teamSelected = widget.selectedTeam.contains(dept2.id);
                    final bool isDetail = dept2 is DepartmentDetailModel;
                    final members2 = isDetail ? dept2.members : const [];
                    final children2 = dept2.children;

                    return Padding(
                      padding: EdgeInsets.only(top: widget.gapDeptTeam.h),
                      child: _TeamTile(
                        name: dept2.name,
                        expanded: teamExpanded,
                        selected: teamSelected,
                        onExpanded: (state) =>
                            widget.onTeamExpanded(state, dept2.id),
                        onSelected: (state) =>
                            widget.onTeamSelected(state, dept2.id),
                        children: [
                          ...members2.map(
                            (m) => Padding(
                              padding: EdgeInsets.only(
                                top: widget.gapDeptTeam.h,
                              ),
                              child: _MemberRow(
                                name: m.mbName,
                                mbInfo: '${m.mbId} ${m.mb5}',
                                selected: widget.selectedMb.contains(m.mbNo),
                                onChanged: (state) =>
                                    widget.onMbSelected(state, m.mbNo),
                              ),
                            ),
                          ),

                          if (members2.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 26,
                                right: 12,
                              ),
                              child: Divider(
                                height: 14,
                                thickness: 1,
                                color: AppColors.subtle,
                              ),
                            ),

                          ...children2.map((dept3) {
                            final teamExpanded = widget.expandedTeam.contains(
                              dept3.id,
                            );
                            final teamSelected = widget.selectedTeam.contains(
                              dept3.id,
                            );
                            final bool isDetail =
                                dept3 is DepartmentDetailModel;
                            final members2 = isDetail
                                ? dept3.members
                                : const [];
                            final children2 = dept3.children;

                            return Padding(
                              padding: EdgeInsets.only(
                                top: widget.gapDeptTeam.h,
                              ),
                              child: _TeamTile(
                                name: dept3.name,
                                expanded: teamExpanded,
                                selected: teamSelected,
                                onExpanded: (state) =>
                                    widget.onTeamExpanded(state, dept3.id),
                                onSelected: (state) =>
                                    widget.onTeamSelected(state, dept3.id),
                                children: [
                                  ...members2.map(
                                    (m) => Padding(
                                      padding: EdgeInsets.only(
                                        top: widget.gapDeptTeam.h,
                                      ),
                                      child: _MemberRow(
                                        name: m.mbName,
                                        mbInfo: '${m.mbId} ${m.mb5}',
                                        selected: widget.selectedMb.contains(
                                          m.mbNo,
                                        ),
                                        onChanged: (state) =>
                                            widget.onMbSelected(state, m.mbNo),
                                      ),
                                    ),
                                  ),

                                  if (members2.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 26,
                                        right: 12,
                                      ),
                                      child: Divider(
                                        height: 14,
                                        thickness: 1,
                                        color: AppColors.subtle,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: widget.gapBetweenGroups.h),
          ],
        );
      }).toList(),
    );
  }
}

// 내부 UI
class _DeptTile extends StatelessWidget {
  final String name;
  final bool selected;
  final bool expanded;
  final Function(bool) onExpanded;
  final Function(bool) onSelected;
  final Widget child;

  const _DeptTile({
    required this.name,
    required this.selected,
    required this.expanded,
    required this.onExpanded,
    required this.onSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onExpanded(!expanded);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: AppColors.subtle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _SquareIconBtn(
                  expanded: expanded,
                  onTap: () {
                    onExpanded(!expanded);
                  },
                ),
                SizedBox(width: 6.w),
                AppCheckbox(
                  value: selected,
                  onChanged: (state) {
                    onSelected(state);
                  },
                  style: AppCheckboxStyle.secondary,
                  size: 24,
                  spacing: 6,
                  compact: true,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.pm16.copyWith(color: AppColors.text),
                  ),
                ),
              ],
            ),
          ),
          if (expanded) child,
        ],
      ),
    );
  }
}

class _TeamTile extends StatelessWidget {
  final String name;
  final bool selected;
  final bool expanded;
  final Function(bool) onExpanded;
  final Function(bool) onSelected;
  final List<Widget> children;

  const _TeamTile({
    required this.name,
    required this.selected,
    required this.expanded,
    required this.onExpanded,
    required this.onSelected,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onExpanded(!expanded);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.fromLTRB(24, 6, 12, 6),
            child: Row(
              children: [
                _SquareIconBtn(
                  expanded: expanded,
                  onTap: () {
                    onExpanded(!expanded);
                  },
                ),
                SizedBox(width: 8.w),
                AppCheckbox(
                  value: selected,
                  onChanged: (state) => onSelected(state),
                  style: AppCheckboxStyle.secondary,
                  size: 24,
                  spacing: 6,
                  compact: true,
                ),
                SizedBox(width: 8.w),
                Expanded(child: Text(name, style: AppTextStyles.pm16)),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final String name;
  final String mbInfo;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _MemberRow({
    required this.name,
    required this.mbInfo,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!selected),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.fromLTRB(48, 6, 12, 6),
        child: Row(
          children: [
            AppCheckbox(
              value: selected,
              onChanged: onChanged,
              style: AppCheckboxStyle.secondary,
              size: 24,
              spacing: 6,
              compact: true,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                children: [
                  Text(
                    name,
                    style: AppTextStyles.psb16.copyWith(
                      color: AppColors.textSec,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    mbInfo,
                    style: AppTextStyles.pm16.copyWith(
                      color: AppColors.textSec,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareIconBtn extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const _SquareIconBtn({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = expanded ? Assets.icons.collapse : Assets.icons.expand;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: icon.svg(width: 24, height: 24),
    );
  }
}
