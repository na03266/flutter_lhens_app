/**
 * 파일명: notice_model.dart
 * 설명: 공지사항 모델
 * 작성자: kangheeyoung
 * 생성일: 25. 8. 13. (수)
 */

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

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isNotice: json['isNotice'] ?? false,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'createdAt': createdAt,
      'isNotice': isNotice,
      'category': category,
    };
  }

  // BoardList에서 사용할 형식으로 변환
  Map<String, dynamic> toBoardListFormat() {
    return {
      'title': title,
      'date': createdAt,
      'notice': isNotice,
      'author': author,
    };
  }
}