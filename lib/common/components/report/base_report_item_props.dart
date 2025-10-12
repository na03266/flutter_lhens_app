import 'package:lhens_app/common/components/base_list_item.dart';

class ReportListItemProps {
  final ItemStatus? status;
  final String typeName;
  final String title;
  final String author;
  final String dateText;
  final int? commentCount;
  final bool secret;

  const ReportListItemProps({
    required this.status,
    required this.typeName,
    required this.title,
    required this.author,
    required this.dateText,
    this.commentCount,
    required this.secret,
  });
}