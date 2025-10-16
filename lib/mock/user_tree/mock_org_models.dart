class Emp {
  final String id;
  final String name;
  final String position; // 사원/대리/기술사원 등
  const Emp({required this.id, required this.name, required this.position});
}

class OrgSite {
  final String name; // 사업소명
  final List<Emp> members;

  const OrgSite({required this.name, this.members = const []});
}

class OrgUnit {
  final String name; // 부서/지사명
  final List<OrgSite> sites; // 하위 사업소들
  final List<Emp> membersDirect; // 사업소 없이 바로 소속된 직원
  const OrgUnit({
    required this.name,
    this.sites = const [],
    this.membersDirect = const [],
  });
}

class OrgDept {
  final String name; // 상위부서
  final List<OrgUnit> units;

  const OrgDept({required this.name, required this.units});
}
