import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/drawer/salary/model/salary_model.dart';
import 'package:lhens_app/drawer/salary/repository/salary_repository.dart';

final salaryProvider =
    StateNotifierProvider<SalaryStateNotifier, SalaryModelBase>((ref) {
      final repository = ref.watch(salaryRepositoryProvider);
      return SalaryStateNotifier(repository: repository);
    });

class SalaryStateNotifier extends StateNotifier<SalaryModelBase> {
  final SalaryRepository repository;

  SalaryStateNotifier({required this.repository})
    : super(SalaryModelLoading()) {
    getSalaries();
  }

  getSalaries({int? year}) async {
    try {
      state = SalaryModelLoading();

      final userResp = await repository.getSalaries(year: year);

      state = userResp;
    } catch (e) {
      state = SalaryModelError(message: '데이터 로딩에 실패했습니다.');
    }
  }

  getSalary({required int id}) async {
    return await repository.getSalary(id: id);
  }
}
