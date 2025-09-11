

class NoticeModel {
  final int id;
  final String title;
  final String content;
  final String author;
  final String createdAt;
  final bool isNotice;
  final String category;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.isNotice,
    required this.category,
  });


}