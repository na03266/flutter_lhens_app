class Employee {
  final String name;
  final String id;
  final String position;

  const Employee({
    required this.name,
    required this.id,
    required this.position,
  });

  String get label => '$name($id)';
}

class Team {
  final String name; // 빈 문자열("")이면 팀 헤더 숨김
  final List<Employee> members;

  const Team({required this.name, required this.members});
}

class Department {
  final String name;
  final List<Team> teams;

  const Department({required this.name, required this.teams});
}
