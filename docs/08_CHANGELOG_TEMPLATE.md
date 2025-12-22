# 08. 릴리즈 노트 (Changelog Template)

## [v1.0.0] - 2026-00-00
### 🚀 주요 변경사항 (Highlights)
*   최초 앱 릴리즈 (Android / iOS)
*   [기능 A] 추가
*   [기능 B] 개선

### ✨ 신규 기능 (New Features)
*   회원가입/로그인 (자동로그인 포함)
*   위험성 평가 게시판 CRUD
*   실시간 채팅 기능

### 🐛 버그 수정 (Bug Fixes)
*   [FIX] 로그인 시 간헐적 401 오류 수정
*   [FIX] 채팅방 목록 갱신 안 되는 문제 해결

### ⚙️ DB / API 변경 (Server Changes)
*   `User` 테이블: `last_login_at` 컬럼 추가
*   API: `POST /board-risk` 파라미터 변경

### ⚠️ 주의사항 (Notes)
*   기존 앱 데이터 호환 불가로 **재설치** 필요합니다.
*   서버 재시작(PM2 reload)이 **2024-00-00 22:00**에 예정되어 있습니다.
