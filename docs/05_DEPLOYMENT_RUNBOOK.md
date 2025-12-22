# 05. 배포 및 운영 가이드 (Deployment & Runbook)

## 1. 환경 설정 (Configuration)

### 1.1 Flutter (Client)
현재 소스코드 상 `lib/common/const/data.dart`에 서버 주소가 하드코딩 되어 있습니다.
운영 환경 분리를 위해 `.env` 도입 혹은 Build Flavors 적용이 권장됩니다.
```dart
// lib/common/const/data.dart
final defaultIp = '110.10.147.37/app'; // [주의] 운영 배포 시 확인 필요
```

### 1.2 NestJS (Server)
*소스코드 미확인으로 일반적인 NestJS 운영 환경 변수를 기술합니다.*
`.env` 파일에 아래 내용이 포함되어야 합니다.
```bash
NODE_ENV=production
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASS=[PLACEHOLDER]
DB_NAME=lhens_db
JWT_SECRET=[PLACEHOLDER]
```

## 2. 배포 절차 (Deployment Process)

### 2.1 Android 배포
1.  **KeyStore 준비**: `lhens_key.jks` 파일 확보 및 `android/key.properties` 설정.
2.  **Version Code 증가**: `pubspec.yaml`의 `version: 1.0.0+1` 수정 (+2).
3.  **빌드**:
    ```bash
    flutter clean
    flutter pub get
    flutter build apk --release
    # 또는 App Bundle
    flutter build appbundle --release
    ```
4.  **산출물**: `build/app/outputs/flutter-apk/app-release.apk`

### 2.2 iOS 배포 (Mac Only)
1.  **Xcode 설정**: Signing & Capabilities에서 Team 선택 및 Provisioning Profile 설정.
2.  **빌드**:
    ```bash
    flutter build ipa --release
    ```
3.  **업로드**: Xcode Organizer 또는 Transporter 앱을 통해 App Store Connect 업로드.

### 2.3 NestJS 서버 배포 (Runbook)
*사용자 가이드(pm2) 기반*
1.  **소스 업데이트**: `git pull origin main`
2.  **의존성 설치**: `npm install`
3.  **빌드**:
    ```bash
    npm run build
    ```
4.  **서비스 재시작 (PM2)**:
    ```bash
    pm2 restart 0
    # 또는
    pm2 reload all
    ```

## 3. 장애 대응 (Troubleshooting)

### 3.1 [장애] 앱에서 데이터 로딩 실패
*   **증상**: 무한 로딩 혹은 "서버 연결 실패" 토스트 발생.
*   **원인**:
    *   서버(NestJS) 다운.
    *   클라이언트 `data.dart`의 IP가 변경됨.
    *   SSL 인증서 만료 (`main.dart`에서 Bypass 중이나, 서버 인증서 자체가 만료되면 문제 발생 가능).
*   **조치**:
    1.  서버 상태 확인 (`pm2 list`, `pm2 logs`).
    2.  `http://110.10.147.37/app/api` 직접 호출 테스트.

### 3.2 [장애] 로그인 풀림 반복
*   **원인**: Refresh Token 만료 혹은 DB 상의 유효하지 않은 토큰.
*   **조치**:
    1.  사용자에게 재로그인 안내.
    2.  서버 로그에서 401 빈도 확인.

### 3.3 [운영] DB 마이그레이션
백엔드 배포 전 마이그레이션이 필수일 수 있습니다.
```bash
# TypeORM 사용 시 (예시)
npm run typeorm migration:run
```
