import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lhens_app/common/components/inputs/app_checkbox.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class UserTree<D, T, M> extends StatelessWidget {
  // 데이터
  final List<D> data;

  // 부서
  final String Function(D) deptName;
  final List<T> Function(D) teamsOf;
  final bool Function(D) isDeptExpanded;
  final void Function(D) onToggleDept;
  // 부서 선택(옵션)
  final bool Function(D)? isDeptSelected;
  final void Function(D, bool)? onToggleDeptSelected;

  // 팀
  final String Function(T) teamName;
  final List<M> Function(T) membersOf;
  final bool Function(D, T) isTeamExpanded;
  final void Function(D, T) onToggleTeam;
  // 팀 선택(옵션)
  final bool Function(D, T)? isTeamSelected;
  final void Function(D, T, bool)? onToggleTeamSelected;

  // 멤버
  final bool Function(M) isMemberSelected;
  final void Function(M, bool) onToggleMember;
  final String Function(M)? memberTitle;
  final String Function(M)? memberSubTitle;

  // 여백
  final double gapBetweenGroups;
  final double gapDeptTeam;
  final double gapTeamMember;

  const UserTree({
    super.key,
    required this.data,
    // dept
    required this.deptName,
    required this.teamsOf,
    required this.isDeptExpanded,
    required this.onToggleDept,
    this.isDeptSelected,
    this.onToggleDeptSelected,
    // team
    required this.teamName,
    required this.membersOf,
    required this.isTeamExpanded,
    required this.onToggleTeam,
    this.isTeamSelected,
    this.onToggleTeamSelected,
    // member
    required this.isMemberSelected,
    required this.onToggleMember,
    this.memberTitle,
    this.memberSubTitle,
    // spacing
    this.gapBetweenGroups = 16,
    this.gapDeptTeam = 3,
    this.gapTeamMember = 0,
  });

  @override
  Widget build(BuildContext context) {
    bool _deptSel(D d) => isDeptSelected?.call(d) ?? false;
    void _toggleDeptSel(D d, bool v) => onToggleDeptSelected?.call(d, v);

    bool _teamSel(D d, T t) => isTeamSelected?.call(d, t) ?? false;
    void _toggleTeamSel(D d, T t, bool v) => onToggleTeamSelected?.call(d, t, v);

    return Column(
      children: [
        for (final d in data) ...[
          _DeptTile(
            name: deptName(d),
            expanded: isDeptExpanded(d),
            selected: _deptSel(d),
            onToggle: () => onToggleDept(d),
            onChanged: (v) => _toggleDeptSel(d, v),
            child: Column(
              children: [
                for (final t in teamsOf(d)) ...[
                  SizedBox(height: gapDeptTeam.h),
                  _TeamTile(
                    name: teamName(t),
                    expanded: isTeamExpanded(d, t),
                    selected: _teamSel(d, t),
                    onToggle: () => onToggleTeam(d, t),
                    onChanged: (v) => _toggleTeamSel(d, t, v),
                    children: [
                      for (final m in membersOf(t)) ...[
                        SizedBox(height: gapTeamMember.h),
                        _MemberRow(
                          title: memberTitle?.call(m) ?? '',
                          subtitle: memberSubTitle?.call(m) ?? '',
                          selected: isMemberSelected(m),
                          onChanged: (v) => onToggleMember(m, v),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: gapBetweenGroups.h),
        ],
      ],
    );
  }
}

// ── 내부 UI ───────────────────────────────────────────────────────────────────

class _DeptTile extends StatelessWidget {
  final String name;
  final bool expanded;
  final bool selected;
  final VoidCallback onToggle;
  final ValueChanged<bool> onChanged;
  final Widget child;

  const _DeptTile({
    required this.name,
    required this.expanded,
    required this.selected,
    required this.onToggle,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: AppColors.subtle,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            children: [
              _SquareIconBtn(expanded: expanded, onTap: onToggle),
              SizedBox(width: 8.w),
              // 체크박스(왼쪽, compact)
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
    );
  }
}

class _TeamTile extends StatelessWidget {
  final String name;
  final bool expanded;
  final bool selected;
  final VoidCallback onToggle;
  final ValueChanged<bool> onChanged;
  final List<Widget> children;

  const _TeamTile({
    required this.name,
    required this.expanded,
    required this.selected,
    required this.onToggle,
    required this.onChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
          child: Row(
            children: [
              _SquareIconBtn(expanded: expanded, onTap: onToggle),
              SizedBox(width: 8.w),
              AppCheckbox(
                value: selected,
                onChanged: onChanged,
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
    );
  }
}

class _MemberRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _MemberRow({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!selected),
      child: Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.fromLTRB(48, 8, 12, 8),
        child: Row(
          children: [
            // 체크박스 왼쪽
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
                  Text(title, style: AppTextStyles.psb16.copyWith(color: AppColors.textSec)),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Text(subtitle, style: AppTextStyles.pm16.copyWith(color: AppColors.textSec)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 공통 토글 아이콘 버튼
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