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
  final bool Function(D)? isDeptSelected;
  final void Function(D, bool)? onToggleDeptSelected;

  // 팀
  final String Function(T) teamName;
  final List<M> Function(T) membersOf;
  final bool Function(D, T) isTeamExpanded;
  final void Function(D, T) onToggleTeam;
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
    required this.deptName,
    required this.teamsOf,
    required this.isDeptExpanded,
    required this.onToggleDept,
    this.isDeptSelected,
    this.onToggleDeptSelected,
    required this.teamName,
    required this.membersOf,
    required this.isTeamExpanded,
    required this.onToggleTeam,
    this.isTeamSelected,
    this.onToggleTeamSelected,
    required this.isMemberSelected,
    required this.onToggleMember,
    this.memberTitle,
    this.memberSubTitle,
    this.gapBetweenGroups = 8,
    this.gapDeptTeam = 4,
    this.gapTeamMember = 0,
  });

  @override
  Widget build(BuildContext context) {
    bool deptSel(D d) => isDeptSelected?.call(d) ?? false;
    void toggleDeptSel(D d, bool v) => onToggleDeptSelected?.call(d, v);

    bool teamSel(D d, T t) => isTeamSelected?.call(d, t) ?? false;
    void toggleTeamSel(D d, T t, bool v) => onToggleTeamSelected?.call(d, t, v);

    return Column(
      children: [
        for (final d in data) ...[
          _DeptTile(
            name: deptName(d),
            expanded: isDeptExpanded(d),
            selected: deptSel(d),
            onToggle: () => onToggleDept(d),
            onChanged: (v) => toggleDeptSel(d, v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < teamsOf(d).length; i++) ...[
                  SizedBox(height: gapDeptTeam.h),

                  Builder(builder: (_) {
                    final t = teamsOf(d)[i];
                    final String tName = teamName(t).trim();
                    final bool isDirect = tName.isEmpty;

                    final bool hasNext = i < teamsOf(d).length - 1;
                    final bool nextIsDirect = hasNext && teamName(teamsOf(d)[i + 1]).trim().isEmpty;

                    // 사이트 사이 구분선, 또는 사이트 → 직접소속 전환선
                    final bool showDividerAfterThisSite = !isDirect && hasNext;

                    final List<Widget> col = [];

                    if (isDirect) {
                      // 직접소속: 헤더 없이 멤버만
                      col.add(
                        Padding(
                          padding: const EdgeInsets.only(left: 26),
                          child: Column(
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
                        ),
                      );
                      // 직접소속 아래엔 구분선 없음
                    } else {
                      // 사업소(팀 타일)
                      col.add(
                        _TeamTile(
                          name: tName,
                          expanded: isTeamExpanded(d, t),
                          selected: teamSel(d, t),
                          onToggle: () => onToggleTeam(d, t),
                          onChanged: (v) => toggleTeamSel(d, t, v),
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
                      );

                      if (showDividerAfterThisSite) {
                        col.add(
                          Padding(
                            padding: const EdgeInsets.only(left: 26, right: 12),
                            child: Divider(
                              height: 14,
                              thickness: 1,
                              color: AppColors.subtle, // 옅은 선
                            ),
                          ),
                        );
                      }
                    }

                    return Column(children: col);
                  }),
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

// 내부 UI

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
              SizedBox(width: 6.w),
              AppCheckbox(
                value: selected,
                onChanged: onChanged,
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
          padding: const EdgeInsets.fromLTRB(24, 6, 12, 6),
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