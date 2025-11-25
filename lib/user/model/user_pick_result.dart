class UserPickResult {
  final List<int> departments; // 선택된 부서(본부)
  final List<int> members; // 선택된 직원 라벨

  const UserPickResult({required this.departments, required this.members});
}
