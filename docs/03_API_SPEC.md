# 03. API 명세 (API Specification)

## 1. 개요
*   **Base URL**: `http://110.10.147.37/app` (개발/운영 공통)
*   **Protocol**: HTTP/1.1
*   **Content-Type**: `application/json`

## 2. 인증 (Authentication)
*   **방식**: Bearer Token (JWT)
*   **Header 규약**:
    *   Client Request Header: `accessToken: 'true'` (Dio Interceptor가 `Authorization: Bearer ...`로 변환)
    *   `refreshToken: 'true'` (토큰 갱신 시 사용)
*   **Automatic Refresh**:
    *   401 Unauthorized 발생 시 `CustomInterceptor`가 자동으로 `/auth/token`을 호출하여 토큰 갱신 후 재요청.

## 3. 엔드포인트 목록 (Endpoints)
*Client Repository Code (`retrofit`) 기반 추론*

### 3.1 회원 (User) - `/user`
| Method | Path | Auth | 설명 | Request | Response |
|:---:|:---|:---:|:---|:---|:---|
| GET | `/me` | O | 내 정보 조회 | - | `UserModel` |
| PATCH | `/password` | O | 비밀번호 변경 | `ChangePasswordDto` | Top-level `void` |
| POST | `/auth/token` | R | 토큰 갱신 | `RefreshToken Header` | `{accessToken}` |

### 3.2 위험성 평가 (Risk) - `/board-risk`
| Method | Path | Auth | 설명 | Request | Response |
|:---:|:---|:---:|:---|:---|:---|
| GET | `/` | O | 게시글 목록 (Pagination) | `PagePaginationParams` | `PagePagination<PostModel>` |
| GET | `/{wrId}` | O | 게시글 상세 | - | `PostDetailModel` |
| POST | `/` | O | 게시글 작성 | `CreatePostDto` | `String?` (ID) |
| POST | `/comment` | O | 댓글 작성 | `CreatePostDto`, `parentId` | `String?` |
| POST | `/comment/reply`| O | 대댓글 작성 | `CreatePostDto`, `parentId`, `commentId` | `String?` |
| PATCH | `/` | O | 게시글 수정 | `CreatePostDto`, `wrId` | `String?` |
| DELETE | `/` | O | 게시글 삭제 | `wrId` | `String?` |

### 3.3 채팅 (Chat) - `/room`
| Method | Path | Auth | 설명 | Request | Response |
|:---:|:---|:---:|:---|:---|:---|
| GET | `/room` | O | 채팅방 목록 | `CursorPaginationParams` | `CursorPagination<ChatRoom>` |
| POST | `/room` | O | 채팅방 생성 | `CreateChatRoomDto` | `String?` |
| GET | `/room/{id}` | O | 채팅방 상세 정보 | - | `ChatRoomDetail` |
| PATCH | `/room/{id}` | O | 채팅방 수정 | `CreateChatRoomDto` | `String` |
| DELETE| `/room/{id}` | O | 채팅방 나가기 | - | `String` |

### 3.4 부서/조직 (Department) - `/department`
| Method | Path | Auth | 설명 | Request | Response |
|:---:|:---|:---:|:---|:---|:---|
| GET | `/` | O | 부서 목록 | - | `DepartmentModelList` |
| GET | `/{id}` | O | 부서원 조회 | - | `DepartmentDetailModel` |

### 3.5 급여 (Salary) - `/salary`
| Method | Path | Auth | 설명 | Request | Response |
|:---:|:---|:---:|:---|:---|:---|
| GET | `/` | O | 급여 목록 | `year` | `SalaryModel` |
| GET | `/html/{id}` | O | 급여 명세서(HTML) | - | `String` (HTML) |

## 4. 에러 규약 (Error Protocol)
*   **HTTP Status Code**:
    *   `200/201`: 성공
    *   `401`: 인증 실패 (토큰 만료 등) -> **Interceptor가 자동 처리**
    *   `500`: 서버 내부 오류
*   **클라이언트 처리**:
    *   DioException 캐치 후 로깅.
    *   401 재발급 실패 시 강제 로그아웃 처리 (`ref.read(authProvider.notifier).logout()`).
