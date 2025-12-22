# 07. 보안 점검 체크리스트 (Security Checklist)

본 문서는 OWASP Mobile Top 10 및 소스코드 분석을 기반으로 작성되었습니다.

## 1. 취약점 분석 보고 (Code Analysis Findings)

### 🚨 Critical Issues
1.  **SSL/TLS 검증 우회 (Insecure HttpOverrides)**
    *   **파일**: `lib/main.dart` (Line 59~72 `InsecureHttpOverrides`)
    *   **내용**: `host == 'lhes.co.kr'` 도메인 등에 대해 인증서 검증을 강제로 `true` 반환.
    *   **위험**: 중간자 공격(MITM)에 취약함. 개발 서버용이라면 배포 시 반드시 제거해야 함.

2.  **Hardcoded Server IP**
    *   **파일**: `lib/common/const/data.dart`
    *   **내용**: `110.10.147.37` IP 노출.
    *   **위험**: IP 변경 시 대응 불가 및 공격 대상 노출 가능성.

### ✅ Good Practices
1.  **Secure Storage 사용**
    *   **내용**: Access/Refresh Token을 `flutter_secure_storage`에 저장하여 기기 내 평문 저장 방지.
    *   **파일**: `lib/common/secure_storage/secure_storage.dart`

2.  **Token Refresh Logic**
    *   **내용**: 401 발생 시 Silent Refresh 수행으로 사용자 편의성 및 세션 관리 구현됨.

## 2. 보안 점검 체크리스트

| 카테고리 | 항목 | 상태 | 비고 |
|:---:|:---|:---:|:---|
| **M1: 권한 사용** | 카메라/갤러리 등 민감 권한 요청 시 근거 명시 | 확인필요 | `AndroidManifest.xml`, `Info.plist` 확인 필요 |
| **M2: 데이터 저장** | 로그에 민감정보(비밀번호, 토큰) 출력 금지 | **취약** | `dio.dart`의 `Generic interceptor`에서 `print`문 사용 중. `debugPrint`로 교체하거나 릴리즈 모드에서 비활성화 필요. |
| **M3: 통신 보안** | 모든 HTTP 통신에 HTTPS 적용 | **취약** | SSL Bypass 코드 존재. |
| **M4: 인증** | 비밀번호 변경/찾기 시 2FA 제공 등 | 확인불가 | 서버 로직 확인 필요. |
| **M5: 입력 검증** | XSS 방지 (HTML 렌더링 시) | 확인필요 | `flutter_html` 사용 중. `UserMeRepository` 등에서 입력값 검증 필요. |

## 3. 권고 사항 (Recommendations)
1.  **프로덕션 배포 전 `main.dart`의 `HttpOverrides` 코드 삭제 혹은 `#if DEBUG` 처리.**
2.  `print()` 함수를 `log()` 혹은 래퍼 함수로 변경하여 릴리즈 빌드에서 로그가 남지 않도록 조치.
3.  앱 난독화(`--obfuscate`) 적용하여 빌드 및 배포.
