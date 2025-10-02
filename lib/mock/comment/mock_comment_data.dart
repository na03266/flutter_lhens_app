import 'mock_comment_models.dart';

const mockComments = <CommentModel>[
  CommentModel(
    user: '김찬주(1001655)',
    time: '2025. 01. 01. 13:57',
    text: '내용 수정 요청합니다. 사진이 잘 보이지 않습니다.\n파일을 다시 첨부해주세요.',
    replies: [
      CommentModel(
        user: '조예빈(1001599)',
        time: '2025. 01. 01. 13:58',
        text: '첨부파일 내용 수정하였습니다. 내용 재확인 부탁드립니다.',
      ),
      CommentModel(
        user: '김찬주(1001655)',
        time: '2025. 01. 01. 14:01',
        text: '확인하였습니다. 감사합니다.',
      ),
    ],
  ),
  CommentModel(
    user: '김찬주(1001655)',
    time: '2025. 01. 01. 13:57',
    text: '댓글 예시입니다.',
    replies: [
      CommentModel(
        user: '조예빈(1001599)',
        time: '2025. 01. 01. 13:58',
        text: '대댓글 예시입니다.',
      ),
    ],
  ),
];
