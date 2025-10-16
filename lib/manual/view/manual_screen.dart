import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/components/doc_list_item.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class ManualScreen extends ConsumerStatefulWidget {
  static String get routeName => '업무매뉴얼';

  const ManualScreen({super.key});

  @override
  ConsumerState<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends ConsumerState<ManualScreen> {
  final TextEditingController _query = TextEditingController();

  String _category = '전체';
  final List<String> _categories = const ['전체'];
  String _appliedQuery = '';
  bool _scrolled = false; // 스크롤 시 검색바 하단 그림자

  final List<({String cat, String title})> _all = List.generate(
    10,
    (_) => (cat: '매뉴얼 카테고리', title: '업무매뉴얼 제목명'),
  );

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems();
    final bool noData = _all.isEmpty;
    final bool noResult = !noData && items.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 검색바 (고정) + 하단 그림자
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  boxShadow: _scrolled ? AppShadows.stickyBar : null,
                ),
                child: FilterSearchBar<String>(
                  items: _categories,
                  selected: _category,
                  getLabel: (v) => v,
                  onSelected: (v) => setState(() => _category = v),
                  controller: _query,
                  onSubmitted: (_) => setState(() {
                    _appliedQuery = _query.text.trim();
                  }),
                ),
              ),
              SizedBox(height: 12.h),

              // 리스트 영역
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is ScrollUpdateNotification) {
                      final atTop = n.metrics.pixels <= 0;
                      if (_scrolled == atTop) {
                        setState(() => _scrolled = !atTop);
                      }
                    }
                    return false;
                  },
                  child: noData
                      ? EmptyState(
                          iconPath: Assets.icons.document.path,
                          message: '등록된 업무매뉴얼이 없습니다.',
                        )
                      : noResult
                      ? EmptyState(
                          iconPath: Assets.icons.search.path,
                          message: '검색어와 일치하는 결과가 없습니다.',
                        )
                      : ListView.separated(
                          physics: const ClampingScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (_, i) => items[i],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _filteredItems() {
    final String q = _appliedQuery;
    final data = (_category == '전체')
        ? _all
        : _all.where((e) => e.cat == _category).toList();

    final filtered = q.isEmpty
        ? data
        : data.where((e) => e.title.contains(q) || e.cat.contains(q)).toList();

    return filtered
        .map(
          (e) => DocListItem(
            category: e.cat,
            title: e.title,
            onPreview: () => debugPrint('[PREVIEW] ${e.title}'),
            onDownload: () => debugPrint('[DOWNLOAD] ${e.title}'),
          ),
        )
        .toList();
  }
}
