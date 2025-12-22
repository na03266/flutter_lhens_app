# 01. 프로젝트 개요 (Overview)

## 1. 프로젝트 목적
**LH EnS Flutter App**은 업무 지원을 위한 모바일 애플리케이션입니다.
관리자와 사용자가 게시판, 채팅, 알림 등의 기능을 통해 효율적으로 소통하고 업무를 처리하는 것을 목표로 합니다.

## 2. 기술 스택 (Tech Stack)
*소스코드(`pubspec.yaml`, `main.dart`) 분석 기반*

| 구분 | 기술 / 라이브러리 | 버전 (Min) | 비고 |
|:---:|:---:|:---:|:---|
| **Language** | Dart | 3.x | Flutter 3.9.0 호환 |
| **Framework** | Flutter | 3.22.0+ (추정) | SDK Constraint `^3.9.0` (Dart) |
| **State Mgt** | **Riverpod** | 2.5.3 | `flutter_riverpod`, `riverpod_annotation` |
| **Routing** | **GoRouter** | 14.6.1 | `go_router` |
| **Network** | Dio | 5.9.0 | with `retrofit` 4.6.0 |
| **Push** | Firebase FCM | 16.0.4 | `firebase_messaging` |
| **Storage** | Flutter Secure Storage | 9.2.4 | 토큰 저장용 |
| **Backend** | NestJS | TBD | *Repository 접근 불가* |

## 3. 주요 기능 (Key Features)
*Flutter `lib/` 폴더 구조 기반*

*   **인증 (User/Auth)**
    *   로그인 (Auto Login 지원), 로그아웃, 비밀번호 변경 (`user/repository/user_me_repository.dart`)
    *   토큰 갱신 (Refresh Token)
*   **게시판/커뮤니티 (Drawer/Board)**
    *   공지사항, 교육/행사, 제안(Complaint)
    *   급여 조회(`salary`), 설문조사(`survey`)
*   **위험 신고 (Risk)**
    *   위험 신고 게시글 조회/작성/수정/삭제
    *   댓글/대댓글 작성 (`risk/repository/risk_repository.dart`)
*   **채팅 (Chat)**
    *   채팅방 목록, 채팅 메시지 전송 (`chat/view/chat_lobby_screen.dart`)
    *   Socket.io 연동 (`socket_io_client`)
*   **알림 (Alarm)**
    *   FCM 푸시 알림 수신 및 목록 조회

## 4. 릴리즈 정보
*   **App Version**: 1.0.0+1 (`pubspec.yaml`)
*   **Target Platforms**: Android, iOS
*   **Server Endpoint**: `http://110.10.147.37/app` (개발/운영 공통 혹은 분리 필요 확인 TBD)

## 5. 잔여 이슈 및 리스크
*   **Backend 접근 권한**: 현재 백엔드 소스코드 확인 불가로, DB 스키마 및 서버 로직 상세 문서화 미비.
*   **Hardcoded IP**: `lib/common/const/data.dart`에 IP(`110.10.147.37`)가 하드코딩 되어 있음. 환경 변수(`flutter_dotenv` 등)로 분리 필요.
*   **SSL Bypass**: `main.dart` 내 `HttpOverrides`가 특정 도메인(`lhes.co.kr` 등)에 대해 인증서 검증을 무시하도록 설정되어 있음. 운영 배포 시 보안 취약점이 될 수 있음.
