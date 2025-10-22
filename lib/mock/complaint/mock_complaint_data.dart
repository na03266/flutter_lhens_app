import 'dart:math';
import 'package:lhens_app/common/components/report/base_list_item.dart'
    show ItemStatus;
import 'package:lhens_app/mock/complaint/mock_complaint_models.dart';

List<ComplaintItem> generateComplaintItems(
  int n, {
  double secretRatio = 0.25, // 비공개 비율
  String authorA = '작성자A', // 내 글
  String authorB = '작성자B', // 타인 글
}) {
  final rng = Random(99);
  const baseTitle = '접수 제목이 표시되는 영역입니다. 접수 제목이 표시되는 영역입니다. 접수 제목이 표시되는 영역입니다.';

  return List<ComplaintItem>.generate(n, (i) {
    final status = switch (i % 3) {
      0 => ItemStatus.received,
      1 => ItemStatus.processing,
      _ => ItemStatus.done,
    };
    final isSecret = rng.nextDouble() < secretRatio;
    final author = (i % 2 == 0) ? authorA : authorB;
    final day = (i % 28 + 1).toString().padLeft(2, '0');

    return ComplaintItem(
      status: status,
      typeName: '민원제안유형명',
      title: baseTitle,
      author: author,
      dateText: '2025. 08. $day',
      comments: i % 7,
      secret: isSecret,
    );
  });
}
