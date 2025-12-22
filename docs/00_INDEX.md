# 문서 목록 (Index)

본 문서는 LH EnS 프로젝트의 기술 및 운영 문서를 포함합니다.

## 1. 문서 체계

| 문서 ID | 문서명 | 주요 내용 | 대상 독자 |
|:---:|:---|:---|:---:|
| **00** | [INDEX](00_INDEX.md) | 문서 목록 및 가이드 | 전원 |
| **01** | [OVERVIEW](01_OVERVIEW.md) | 프로젝트 개요, 기술 스택, 릴리즈 요약 | 전원 |
| **02** | [ARCHITECTURE](02_ARCHITECTURE.md) | 시스템 구성도, 아키텍처 (Flutter/NestJS) | 개발/운영 |
| **03** | [API_SPEC](03_API_SPEC.md) | API 명세, 인증/에러 규약 (Client Code 기반 추론) | 개발 |
| **04** | [DATA_MODEL](04_DATA_MODEL.md) | 데이터 모델, DTO 매핑 | 개발/DBA |
| **05** | [DEPLOYMENT_RUNBOOK](05_DEPLOYMENT_RUNBOOK.md) | 배포 절차, 환경 설정, 운영/장애 대응 | 운영/DevOps |
| **06** | [TESTING_QA](06_TESTING_QA.md) | 테스트 가이드, TC, 결함 기준 | QA/개발 |
| **07** | [SECURITY_CHECKLIST](07_SECURITY_CHECKLIST.md) | 보안 점검 리스트 (인증, 네트워크 등) | 보안/개발 |
| **08** | [CHANGELOG_TEMPLATE](08_CHANGELOG_TEMPLATE.md) | 릴리즈 노트 작성 템플릿 | PM/개발 |

## 2. 권장 읽기 순서
- **신규 입사자/인수인계**: 01 -> 02 -> 05
- **백엔드/API 개발자**: 02 -> 03 -> 04
- **오픈/운영 이관 시**: 05 -> 07 -> 01 (릴리즈 노트 확인)

