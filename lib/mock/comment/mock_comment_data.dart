import 'mock_comment_models.dart';

const mockComments = <CommentModel>[
  CommentModel(
    id: 'c1',
    user: '김찬주(1001655)',
    time: '2025. 01. 01. 13:57',
    text: '내용 수정 요청합니다. 사진이 잘 보이지 않습니다. 파일을 다시 첨부해주세요.',
    replies: [
      CommentModel(
        id: 'r1',
        user: '조예빈(1001599)',
        time: '2025. 01. 01. 13:58',
        text: '첨부파일 내용 수정하였습니다. 내용 재확인 부탁드립니다.',
      ),
      CommentModel(
        id: 'r2',
        user: '김찬주(1001655)',
        time: '2025. 01. 01. 14:01',
        text: '확인하였습니다. 감사합니다.',
      ),
    ],
  ),
  CommentModel(
    id: 'c2',
    user: '김찬주(1001655)',
    time: '2025. 01. 01. 13:57',
    text: '댓글 예시입니다.',
    replies: [
      CommentModel(
        id: 'r3',
        user: '조예빈(1001599)',
        time: '2025. 01. 01. 13:58',
        text: '대댓글 예시입니다.',
      ),
    ],
  ),
];

// 전체 댓글 수 계산 (임시)
int get mockTotalCommentCount {
  int countReplies(CommentModel c) {
    int total = 1;
    for (final r in c.replies) {
      total += countReplies(r);
    }
    return total;
  }

  return mockComments.fold<int>(0, (sum, c) => sum + countReplies(c));
}