// lib/common/components/report/report_form_config.dart

/// 입력 잠금 모드
enum FormLockMode { none, readOnly, disabled }

/// 폼 동작 및 초기값 설정
class ReportFormConfig {
  // 기본 입력
  final String titleHint;
  final String contentHint;
  final List<String> typeItems;

  // 대상 선택
  final bool showTargets;
  final Future<({List<String> depts, List<String> users})?> Function()? onPickTargets;
  final List<String> fixedTargets;

  // 제출
  final String submitText;
  final void Function(ReportFormValue value) onSubmit;

  // 수정/권한
  final bool isEdit;
  final bool canEditStatus;
  final List<String> statusItems;
  final String? selectedStatus;
  final bool canEditSecret;
  final FormLockMode lockMode;

  // 초기 값
  final String? initialType;
  final String? initialTitle;
  final String? initialContent;
  final bool? initialSecret;
  final List<String> initialFiles;
  final List<String> initialTargetDepts;
  final List<String> initialTargetUsers;

  const ReportFormConfig({
    // 기본 입력
    required this.titleHint,
    required this.contentHint,
    required this.typeItems,
    // 대상 선택
    required this.showTargets,
    this.onPickTargets,
    this.fixedTargets = const [],
    // 제출
    this.submitText = '등록',
    required this.onSubmit,
    // 수정/권한
    this.isEdit = false,
    this.canEditStatus = false,
    this.statusItems = const ['접수', '처리중', '완료'],
    this.selectedStatus,
    this.canEditSecret = true,
    this.lockMode = FormLockMode.none,
    // 초기 값
    this.initialType,
    this.initialTitle,
    this.initialContent,
    this.initialSecret,
    this.initialFiles = const [],
    this.initialTargetDepts = const [],
    this.initialTargetUsers = const [],
  });
}

/// 폼 제출 값
class ReportFormValue {
  final String? type;
  final String title;
  final String content;
  final bool secret;
  final List<String> files;
  final List<String> targetDepts;
  final List<String> targetUsers;
  final String? status;

  const ReportFormValue({
    required this.type,
    required this.title,
    required this.content,
    required this.secret,
    required this.files,
    required this.targetDepts,
    required this.targetUsers,
    this.status,
  });
}