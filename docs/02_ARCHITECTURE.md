# 02. 아키텍처 (Architecture)

## 1. 전체 시스템 구성도 (System Context)

```mermaid
graph TD
    User([사용자 app])
    LB[Load Balancer / Nginx (TBD)]
    API[NestJS API Server]
    DB[(MySQL/TBD)]
    FCM[Firebase Cloud Messaging]
    Socket[Socket.IO Server]

    User -- HTTP/REST --> API
    User -- WebSocket --> Socket
    API -- Read/Write --> DB
    API -- Push Request --> FCM
    FCM -- Push Notification --> User
```

## 2. Flutter 클라이언트 아키텍처

### 2.1 디렉토리 구조 (Feature-first Pattern)
기능(Feature) 단위로 폴더를 구분하고, 공통 모듈은 `common`에 배치하는 구조입니다.

```text
lib/
├── common/             # 공통 컴포넌트, 상수, 유틸리티, 네트워크 설정
│   ├── dio/            # Dio 클라이언트 및 Interceptor (Auth Token 처리)
│   ├── provider/       # 전역 Provider (GoRouter 등)
│   └── secure_storage/ # 로컬 보안 저장소 관리
├── user/               # 회원/인증 관련 기능
│   ├── auth/           # 로그인, 토큰 관리 로직
│   ├── repository/     # 회원 API (Retrofit)
│   └── view/           # 로그인 화면 등
├── risk/               # 위험성 평가 기능
├── drawer/             # 햄버거 메뉴 하위 기능 (공지, 급여, 설문 등)
├── chat/               # 채팅 기능
└── main.dart           # 앱 진입점, ProviderScope, Router 설정
```

### 2.2 상태 관리 (State Management)
*   **Riverpod**를 사용합니다.
*   `Provider`, `StateNotifierProvider` 등을 사용하여 비즈니스 로직과 UI를 분리합니다.
*   API 호출 결과는 Repository -> Provider 순으로 전달되어 UI(ConsumerWidget)에서 구독합니다.

### 2.3 라우팅 (Routing)
*   **GoRouter**를 사용합니다 (`common/provider/go_router.dart`).
*   `authProvider`의 리디렉션 로직(`redirectLogic`)을 통해 로그인 여부에 따라 로그인 화면 또는 메인 화면으로 자동 이동합니다.

### 2.4 네트워크 계층
*   **Dio + Retrofit** 조합을 사용합니다.
*   `CustomInterceptor` (`common/dio/dio.dart`)에서 다음 기능을 수행합니다:
    *   **Request**: `accessToken: 'true'` 헤더가 있으면 Storage의 토큰을 `Authorization: Bearer` 헤더로 교체.
    *   **Error (401)**: 토큰 만료 시 `/auth/token` 엔드포인트를 통해 토큰 갱신 시도 후 재요청 (Silent Refresh).

## 3. NestJS 서버 아키텍처 (추정)
*소스코드 접근 불가로 Client API 호출 패턴 기반 추정*

*   **API 구조**: RESTful API
*   **인증**: JWT (Access + Refresh Token) 방식
*   **주요 모듈 (예상)**:
    - UserModule (`/user`)
    - AuthModule (`/auth`)
    - BoardRiskModule (`/board-risk`)
    - ChatModule (WebSocket Gateway 포함 예상)
