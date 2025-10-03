import 'package:lhens_app/common/components/base_list_item.dart'
    show ItemStatus;

class ComplaintItem {
  final ItemStatus status;
  final String typeName;
  final String title;
  final String author;
  final String dateText;
  final int comments;
  final bool secret;

  const ComplaintItem({
    required this.status,
    required this.typeName,
    required this.title,
    required this.author,
    required this.dateText,
    required this.comments,
    required this.secret,
  });
}
