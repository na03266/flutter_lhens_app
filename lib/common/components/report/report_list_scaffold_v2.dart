import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/app_segmented_tabs.dart';
import 'package:lhens_app/common/components/buttons/fab_add_button.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/pagination_bar.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/provider/page_pagination_providar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';

typedef PaginationWidgetBuilder<T> =
    Widget Function(BuildContext context, int index, T model);

class ReportListScaffoldV2<T> extends ConsumerStatefulWidget {
  final List<String> tabs;
  final List<String> filters;
  final Function(String) selectTabName;
  final Function(String) selectFilterName;
  final Function(String) onSearched;
  final bool mineOnly;
  final Function()? addPost;
  final Function(int) changePage;
  final PaginationWidgetBuilder<T> itemBuilder;
  final StateNotifierProvider<PagePaginationProvider, PagePaginationBase>
  provider;

  const ReportListScaffoldV2({
    super.key,
    required this.tabs,
    required this.filters,
    required this.selectTabName,
    required this.selectFilterName,
    required this.onSearched,
    required this.itemBuilder,
    required this.provider,
    required this.changePage,
    this.addPost,
    this.mineOnly = false,
  });

  @override
  ConsumerState<ReportListScaffoldV2<T>> createState() =>
      _ReportListScaffoldState<T>();
}

class _ReportListScaffoldState<T>
    extends ConsumerState<ReportListScaffoldV2<T>> {
  final _searchInputController = TextEditingController();
  bool _scrolled = false;
  late String _selectedFilter = '';
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.filters[0];
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    super.dispose();
  }

  Widget _emptyTop(String iconPath, String message) {
    return Column(
      children: [
        const Spacer(flex: 2),
        EmptyState(iconPath: iconPath, message: message),
        const Spacer(flex: 3),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hPad = 16.w;

    final state = ref.watch(widget.provider);

    // 최초 로딩
    if (state is PagePaginationLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // 에러
    if (state is PagePaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message, textAlign: TextAlign.center),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시 시도'),
          ),
        ],
      );
    }

    final cp = state as PagePagination<T>;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 탭
            AppSegmentedTabs(
              index: _tabIndex,
              rightTabs: widget.tabs,
              onChanged: (tabIndex) => setState(() {
                _tabIndex = tabIndex;
                if (tabIndex == 0) {
                  widget.selectTabName('');
                } else {
                  widget.selectTabName(widget.tabs[tabIndex - 1]);
                }
              }),
            ),
            SizedBox(height: 16.h),

            // 검색바
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: _scrolled ? AppShadows.stickyBar : null,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 12.h),
                child: FilterSearchBar<String>(
                  items: widget.filters,
                  selected: _selectedFilter,
                  getLabel: (v) => v,
                  onSelected: (selectedItem) => setState(() {
                    _selectedFilter = selectedItem;
                    widget.selectFilterName(selectedItem);
                  }),
                  controller: _searchInputController,
                  onSubmitted: (_) {
                    widget.onSearched(_searchInputController.text.trim());
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // 본문
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
                child: cp.data.isEmpty
                    ? _emptyTop(Assets.icons.document.path, '등록된 게시물이 없습니다.')
                    : ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        itemCount: cp.data.length + 2,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 2.w,
                                right: 2.w,
                                bottom: 8.h,
                              ),
                              child: CountInline(
                                label: '전체',
                                count: cp.meta.count,
                              ),
                            );
                          }
                          if (index == cp.data.length + 1) {
                            return Padding(
                              padding: EdgeInsets.only(top: 12.h, bottom: 80.h),
                              child: Center(
                                child: PaginationBar(
                                  currentPage: cp.meta.page,
                                  totalPages: (cp.meta.count / cp.meta.take)
                                      .ceil(),
                                  onPageChanged: (page) =>
                                      widget.changePage(page),
                                ),
                              ),
                            );
                          }
                          final pItem = cp.data[index - 1];

                          return widget.itemBuilder(context, index - 1, pItem);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: widget.addPost != null
          ? Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: FabAddButton(onTap: () => widget.addPost),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
