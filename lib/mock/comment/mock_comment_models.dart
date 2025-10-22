class CommentModel {
  final String id;
  final String user;
  final String time;
  final String text;
  final List<CommentModel> replies;

  const CommentModel({
    required this.id,
    required this.user,
    required this.time,
    required this.text,
    this.replies = const [],
  });

  bool get hasReplies => replies.isNotEmpty;
}