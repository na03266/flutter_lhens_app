import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/appBorderRadius.dart';
import '../../const/appColorPicker.dart';
import '../../const/appPadding.dart';
import '../tabbar/custom_tab.dart';

class BoardImg extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> listData;

  const BoardImg({
    super.key,
    required this.title,
    required this.listData,
  });

  @override
  State<BoardImg> createState() => _BoardImgState();
}

class _BoardImgState extends State<BoardImg> {
  late List<Map<String, dynamic>> _filteredList;
  late List<String> _tabs;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabs = ['전체'];
    _tabs.addAll(widget.listData
        .map((e) => e['type'] as String?)
        .whereType<String>()
        .toSet()
        .toList());

    _filterList(); // 초기 리스트 필터링
  }

  void _filterList() {
    final selectedTab = _tabs[_selectedTabIndex];
    setState(() {
      if (selectedTab == '전체') {
        _filteredList = List.from(widget.listData);
      } else {
        _filteredList =
            widget.listData.where((item) => item['type'] == selectedTab).toList();
      }
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _filterList();
  }

  @override
  Widget build(BuildContext context) {
    // 필터 리스트가 null일 경우 빈 리스트로 방어적 처리
    final displayList = _filteredList ?? [];

    return Padding(
      padding: AppPaddings.homeNoRight,
      child: Column(
        children: [
          /// 타이틀 영역
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
                Image.asset('asset/image/plus.png', width: 24, height: 24),
              ],
            ),
          ),

          // 구분선
          // Padding(
          //   padding: AppPaddings.title,
          //   child: const Divider(height: 1, thickness: 1, color: AppColors.tableLineColor,),
          // ),

          /// 탭 영역
          CustomTab(
            listData: widget.listData,
            // onTabFiltered: (filteredList) {
            //   WidgetsBinding.instance.addPostFrameCallback((_) {
            //     setState(() {
            //       _filteredList = filteredList;
            //     });
            //   });
            // },
            paddingSize: AppPaddings.tab,
            selectedBorderColor: AppColors.primaryColor,
            unselectedBackgroundColor: Colors.white,
            selectedBackgroundColor: Colors.white,
            selectedTextColor: AppColors.primaryColor,
            unselectedTextColor: AppColors.tabTitleColor,
            borderRadius: AppBorderRadius.radius60,
            isExpanded: false
          ),

          const SizedBox(height: 12),

          /// 슬라이드 카드 리스트
          SizedBox(
            height: 200,
            child: displayList.isEmpty
                ? Center(child: Text('내용이 없습니다.'))
                : PageView.builder(
              controller: PageController(
                viewportFraction: 0.45,
                initialPage: 0
              ),
              padEnds: false,
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final item = _filteredList[index];

                return Padding(
                  padding: AppPaddings.img,
                  child: Card(
                    elevation: 0, // 그림자 없애기
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.radius9,
                    ),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 이미지 영역
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: AppBorderRadius.radius9,
                              ),
                              child: const Center(child: Text('Image')),
                            ),
                          ),
                          const SizedBox(height: 8),

                          /// 제목 + 타입
                          eventView(item),

                          const SizedBox(height: 4),

                          /// 날짜
                          Text(
                            '기  간 | ${item['date'] ?? ''}',
                            style: TextStyle(fontSize: 13.r, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// 교육 행사 정보 화면 영역
Widget eventView(Map<String, dynamic> item) {
  return Container(
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item['title'] ?? '',
            style: TextStyle(fontSize: 18.r, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: AppPaddings.box,
          decoration: BoxDecoration(
            color: item['type'] == '교육'
                ? AppColors.darkBlueColor.withOpacity(0.1)
                : item['type'] == '행사'
                ? AppColors.primaryColor.withOpacity(0.1)
                : Colors.grey[200],
            borderRadius: AppBorderRadius.radius10,
          ),
          child: Text(
            item['type'] ?? '',
            style: TextStyle(
              fontSize: 10.r,
              fontWeight: FontWeight.w100,
              color: item['type'] == '교육'
                  ? AppColors.darkBlueColor
                  : item['type'] == '행사'
                  ? Colors.black
                  : Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}