import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';

class EduEventDetailScreen extends ConsumerWidget {
  static String get routeName => '교육행사 상세';

  const EduEventDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const type = '교육 정보';
    const title = '2025 안전보건 규정 변경 및 실무교육';

    return ReportDetailScaffold(
      config: ReportDetailConfig(
        typeName: type,
        title: title,
        headerBuilder: (_) => const ReportDetailHeader(
          typeName: type,
          title: title,
          onMoreTap: null,
        ),
        metaRows: const [
          LabelValueLine.single(label1: '수신부서', value1: '기획조정실 안전보건팀'),
          LabelValueLine.single(
            label1: '기간',
            value1: '2025. 01. 15 ~ 2025. 01. 16',
          ),
          LabelValueLine.single(label1: '작성자', value1: 'LH E&S'),
          LabelValueLine.single(label1: '등록일', value1: '2025. 01. 05'),
          LabelValueLine.single(label1: '조회수', value1: '278'),
        ],
        body: const _EduEventBody(),
        attachments: const ['첨부파일명.pdf'],
        editRouteName: '교육행사 수정',
        showComments: false,
        showBackToListButton: true,
        onBackToList: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _EduEventBody extends StatelessWidget {
  const _EduEventBody();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '2025년 개정된 산업안전보건법과 관련 규정을 이해하고 현장 안전관리자의 실무 적용 능력을 강화하기 위한 교육입니다.\n\n'
      '주요 내용은 개정 법령의 핵심 조항과 공공기관 적용 의무사항 설명, 최근 사고 사례 분석과 대응 프로세스 공유, 체크리스트 기반 위험성 평가 실습, 안전문화 정착과 내부 보고 체계 개선 방안 등입니다.\n\n'
      '교육은 외부 전문가 강의와 내부 사례 발표, 그룹별 실습 및 토론으로 구성되며, 모든 참석자는 사전 배포된 요약본을 숙지하고 개인 노트북이나 태블릿을 지참해야 합니다.\n\n'
      '교육 종료 후 만족도 조사를 실시하고 수료증을 발급하며, 자료와 개선된 절차는 인트라넷에 공유될 예정입니다.\n\n'
      '임시 데이터이며 실제 데이터 연동 시 대체됩니다.',
    );
  }
}
