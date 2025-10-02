class UserPickResult {
  final List<String> departments; // 선택된 부서(본부)
  final List<String> members; // 선택된 직원 라벨

  const UserPickResult({
    required this.departments,
    required this.members,
  });
}
