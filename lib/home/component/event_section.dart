// home/component/home_event_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import 'home_section_header.dart';
import 'home_filter_chip.dart';
import 'home_event_card.dart';

class EventSection extends StatefulWidget {
  const EventSection({super.key});

  @override
  State<EventSection> createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {
  // 상태
  HomeFilter _filter = HomeFilter.all;
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  // 필터 변경 시 스크롤을 맨 앞으로 자연스럽게 이동
  void _setFilter(HomeFilter f) {
    setState(() => _filter = f);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // _cardsForFilter만 교체하세요.
  List<Widget> _cardsForFilter(double cardW, double gap) {
    final edu1 = SizedBox(
      width: cardW,
      child: HomeEventCard(
        width: cardW,
        title: '교육 예시입니다. 내용이 길어질 경우 줄바꿈 처리',
        periodText: '2025.06.02 ~ 2025.06.03',
        imagePath: Assets.images.event.path,
        onTap: () {},
      ),
    );

    final edu2 = SizedBox(
      width: cardW,
      child: HomeEventCard(
        width: cardW,
        title: '교육 예시입니다. 내용이 길어질 경우 줄바꿈 처리',
        periodText: '2025.06.12 ~ 2025.06.12',
        imagePath: Assets.images.event.path,
        onTap: () {},
      ),
    );

    final event1 = SizedBox(
      width: cardW,
      child: HomeEventCard(
        width: cardW,
        title: '행사 예시입니다. 제목이 길어질 경우 줄바꿈 처리',
        periodText: '2025.07.05 ~ 2025.07.06',
        imagePath: Assets.images.event.path,
        onTap: () {},
      ),
    );

    final event2 = SizedBox(
      width: cardW,
      child: HomeEventCard(
        width: cardW,
        title: '행사 예시입니다. 제목이 길어질 경우 줄바꿈 처리',
        periodText: '2025.07.15 ~ 2025.07.19',
        imagePath: Assets.images.event.path,
        onTap: () {},
      ),
    );

    switch (_filter) {
      case HomeFilter.all:
        return [
          edu1,
          SizedBox(width: gap),
          edu2,
          SizedBox(width: gap),
          event1,
          SizedBox(width: gap),
          event2,
        ];
      case HomeFilter.edu:
        return [edu1, SizedBox(width: gap), edu2];
      case HomeFilter.event:
        return [event1, SizedBox(width: gap), event2];
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontal = 16.w;
    final gap = 16.w;
    final minW = 160.w;
    final maxW = 220.w;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final avail = constraints.maxWidth;

          // 화면에 약 1.8장 보이도록 카드 너비 산출
          const visibleCount = 1.8;
          double cardW = (avail - gap) / visibleCount;
          cardW = cardW.clamp(minW, maxW);

          // 리스트 높이(3:2 이미지 + 텍스트 영역 여유)
          final imageH = cardW * 2 / 3;
          final listH = imageH + 12.h + 66.h +12.h;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeSectionHeader(title: '교육·행사 정보'),
              SizedBox(height: 12.h),
              HomeFilterChip(selected: _filter, onChanged: _setFilter),
              SizedBox(height: 16.h),
              SizedBox(
                height: listH,
                child: ListView(
                  controller: _scroll,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(right: 16.w),
                  children: _cardsForFilter(cardW, gap),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
