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
  HomeFilter _filter = HomeFilter.all;
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _setFilter(HomeFilter f) {
    if (_filter == f) return;
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

  // 카드
  Widget _buildCard(
    double cardW, {
    required String title,
    required String period,
  }) {
    return SizedBox(
      width: cardW,
      child: HomeEventCard(
        title: title,
        periodText: period,
        imagePath: Assets.images.event.path,
        onTap: () {},
      ),
    );
  }

  // 간격
  List<Widget> _withGap(List<Widget> items, double gap) {
    if (items.isEmpty) return const [];
    return [
      for (int i = 0; i < items.length; i++) ...[
        items[i],
        if (i != items.length - 1) SizedBox(width: gap),
      ],
    ];
  }

  List<Widget> _cardsFor(double cardW, double gap) {
    final edu1 = _buildCard(
      cardW,
      title: '교육 예시입니다. 제목이 길어질 경우 줄바꿈 처리',
      period: '2025.06.02 ~ 2025.06.03',
    );
    final edu2 = _buildCard(
      cardW,
      title: '교육 예시입니다. 제목이 길어질 경우 줄바꿈 처리',
      period: '2025.06.12 ~ 2025.06.12',
    );
    final event1 = _buildCard(
      cardW,
      title: '행사 예시입니다. 제목이 길어질 경우 줄바꿈 처리',
      period: '2025.07.05 ~ 2025.07.06',
    );
    final event2 = _buildCard(
      cardW,
      title: '행사 예시입니다. 제목이 길어질 경우 줄바꿈 처리',
      period: '2025.07.15 ~ 2025.07.19',
    );

    switch (_filter) {
      case HomeFilter.all:
        return _withGap([edu1, edu2, event1, event2], gap);
      case HomeFilter.edu:
        return _withGap([edu1, edu2], gap);
      case HomeFilter.event:
        return _withGap([event1, event2], gap);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad = 16.w;
    final gap = 16.w;
    final minW = 160.w;
    final maxW = 220.w;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: LayoutBuilder(
        builder: (context, c) {
          // 약 1.8장 보이도록 카드 폭 계산
          const visible = 1.8;
          double cardW = (c.maxWidth - gap) / visible;
          cardW = cardW.clamp(minW, maxW);

          // 리스트 높이: 3:2 이미지 + 텍스트 여유
          final imageH = cardW * 2 / 3;
          final listH = imageH + 12.h + 66.h + 12.h;

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
                  children: _cardsFor(cardW, gap),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
