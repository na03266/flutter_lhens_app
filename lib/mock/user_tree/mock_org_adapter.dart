import 'mock_org_models.dart';
import 'mock_org_data.dart';
import 'mock_user_tree_models.dart';

/// 4단계 Org → 3단계 UI 변환
/// Department.name = OrgUnit.name
/// Team = 각 사업소 + (직접소속은 팀 헤더 숨김: name = "")
List<Department> adaptOrgToUserTree(List<OrgDept> org) {
  final out = <Department>[];

  for (final dept in org) {
    for (final unit in dept.units) {
      final teams = <Team>[];

      // 사업소 → 팀
      for (final site in unit.sites) {
        teams.add(
          Team(
            name: site.name,
            members: site.members
                .map(
                  (e) => Employee(name: e.name, id: e.id, position: e.position),
                )
                .toList(),
          ),
        );
      }

      // 직접소속 → 팀 헤더 숨김용(빈 이름)
      if (unit.membersDirect.isNotEmpty) {
        teams.add(
          Team(
            name: '', // ← 빈 문자열이면 UserTree에서 팀 헤더 렌더 생략
            members: unit.membersDirect
                .map(
                  (e) => Employee(name: e.name, id: e.id, position: e.position),
                )
                .toList(),
          ),
        );
      }

      if (teams.isNotEmpty) {
        out.add(Department(name: unit.name, teams: teams));
      }
    }
  }

  return out;
}

/// 화면에서 바로 사용
final List<Department> kMockDepartments = adaptOrgToUserTree(kMockOrg);
