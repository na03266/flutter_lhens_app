import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/drawer/edu_event/view/edu_event_screen.dart';
import 'package:lhens_app/home/model/home_model.dart';

import '../provider/home_provider.dart';
import 'home_section_header.dart';
import 'home_filter_chip.dart';
import 'home_event_card.dart';

class EventSection extends ConsumerStatefulWidget {
  const EventSection({super.key});

  @override
  ConsumerState<EventSection> createState() => _EventSectionState();
}

class _EventSectionState extends ConsumerState<EventSection> {
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

    // 필터 변경 시 리스트 맨 앞으로 스크롤
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

  void _goEduEvent() => context.pushNamed(EduEventScreen.routeName);

  Widget _card(
    double cardW, {
    required String title,
    required String period,
    required String imagePath,
  }) {
    return SizedBox(
      width: cardW,
      child: HomeEventCard(
        title: title,
        periodText: period,
        imagePath: imagePath,
        onTap: _goEduEvent,
      ),
    );
  }

  List<Widget> _withGap(List<Widget> items, double gap) {
    if (items.isEmpty) return const [];
    return [
      for (int i = 0; i < items.length; i++) ...[
        items[i],
        if (i != items.length - 1) SizedBox(width: gap),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final hPad = 16.w;
    const visibleCards = 2; // 약 1.8장 보이도록
    final gap = 16.w;
    final minW = 160.w;
    final maxW = 220.w;

    final state = ref.watch(homeProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: LayoutBuilder(
        builder: (context, c) {
          double cardW = (c.maxWidth - gap) / visibleCards;
          cardW = cardW.clamp(minW, maxW);

          // 리스트 높이: 3:2 이미지 + 텍스트 여유
          final imageH = cardW * 2 / 3;
          final listH = imageH + 12.h + 66.h + 12.h;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSectionHeader(title: '교육·행사 정보', onTap: _goEduEvent),
              // SizedBox(height: 12.h),
              // HomeFilterChip(selected: _filter, onChanged: _setFilter),
              SizedBox(height: 16.h),
              SizedBox(
                height: listH,
                child: ListView(
                  controller: _scroll,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(right: 16.w),
                  children: state is HomeModel && state.eventItems.isNotEmpty
                      ? _withGap(
                          state.eventItems
                              .map(
                                (e) => _card(
                                  cardW,
                                  title: e.wrSubject,
                                  period: e.wr4,
                                  imagePath: e.wr5,
                                ),
                              )
                              .toList(),
                          gap,
                        )
                      : [],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
