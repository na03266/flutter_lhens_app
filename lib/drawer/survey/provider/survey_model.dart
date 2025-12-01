import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/provider/page_pagination_providar.dart';
import 'package:lhens_app/drawer/survey/model/survey_model.dart';
import 'package:lhens_app/drawer/survey/repository/survey_repository.dart';

final surveyDetailProvider = Provider.family<SurveyModel?, String>((ref, id) {
  final state = ref.watch(surveyProvider);
  if (state is! PagePagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.wrId == int.parse(id));
});

final surveyProvider =
StateNotifierProvider<SurveyStateNotifier, PagePaginationBase>((ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  final notifier = SurveyStateNotifier(repository: repository);

  return notifier;
});

class SurveyStateNotifier
    extends PagePaginationProvider<SurveyModel, SurveyRepository> {
  SurveyStateNotifier({required super.repository});

  getDetail({required String wrId}) async {
    if (state is! PagePagination) {
      await paginate();
    }
    if (state is! PagePagination) {
      return;
    }

    final pState = state as PagePagination;

    final resp = await repository.getSurveyDetail(wrId: wrId);

    final parsedWrId = int.parse(wrId);
    if (pState.data.where((e) => e.wrId == parsedWrId).isEmpty) {
      state = pState.copyWith(data: <SurveyModel>[...pState.data, resp]);
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<SurveyModel>((e) => e.wrId == parsedWrId ? resp : e)
            .toList(),
      );
    }
  }

}
